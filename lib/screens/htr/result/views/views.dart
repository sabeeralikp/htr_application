import 'dart:developer';
//import 'dart:html' as html;
import 'dart:io';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:htr/screens/htr/segment/widgets/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:htr/screens/htr/result/widgets/widgets.dart';

///
/// [ResulPage]
///
/// [author]	Sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	March 1st, 2023 1:14 PM
/// [see]		StatefulWidget
///
///A stateful widget for the ResultPage.
///The ResultPage displays the results based on the provided arguments.

class ResulPage extends StatefulWidget {
  final List<dynamic>? args;

  ///Constructs a new instance of the ResultPage.
  ///The [args] parameter is a list of dynamic values that will be used to display the results.
  const ResulPage({this.args, super.key});
  @override
  State<ResulPage> createState() => _ResulPageState();
}

///The state class for the ResultPage widget.
///It manages the state of the ResultPage and contains the logic for initializing the widget, including handling the provided arguments.
class _ResulPageState extends State<ResulPage> {
  final fq.QuillController _controller = fq.QuillController.basic();
  List<SaveDataModel> saveDatas = [];
  int selectedIndex = -1;
  List<bool> isSelected = [false, true];
  @override
  void initState() {
    super.initState();

    /// Initialize the state of the widget
    if (widget.args != null) {
      String words = "";

      /// Iterate over the provided arguments and process them
      for (int i = 0; i < widget.args!.length ~/ 2; i++) {
        words = "$words ${widget.args![i]}";
        log((widget.args![i + (widget.args!.length ~/ 2)]['id']).toString());
        log((widget.args![i]).toString());
        saveDatas.add(SaveDataModel(
            imageCordinate: widget.args![i + (widget.args!.length ~/ 2)]['id'],
            annotatedText: widget.args![i]));
      }

      /// Insert the processed words into the Quill editor
      _controller.document.insert(0, words.replaceFirst(" ", ""));
    }
    if (mounted) {
      _showFeedbackDialog();
    }
  }

  ///Saves the PDF document.
  ///The [pdf] parameter represents the PDF document to be saved.
  ///If the platform is not web (i.e., mobile or desktop), the PDF document is saved locally on the device.
  ///Otherwise, on the web, the PDF is saved by creating a Blob object and generating a download link for the user.
  savePDf(pdf) async {
    if (!kIsWeb) {
      /// Save the PDF locally on the device
      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/document.pdf");
      await file.writeAsBytes(await pdf.save());
      log(output.path);
      showSavedSnackbar(output.path, 'document.pdf');
    } else {
      /// Save the PDF on the web by creating a Blob object and generating a download link
      // final bytes = await pdf.save();
      // final blob = html.Blob([bytes], 'application/pdf');
      // final url = html.Url.createObjectUrlFromBlob(blob);
      // final anchor = html.AnchorElement()
      //   ..href = url
      //   ..style.display = 'none'
      //   ..download = 'document.pdf';
      // html.document.body?.children.add(anchor);
      // anchor.click();
      // html.document.body?.children.remove(anchor);
      // html.Url.revokeObjectUrl(url);
    }
  }

  ///Saves the PDF document as a DOCX file.
  ///The [pdf] parameter represents the PDF document to be saved as DOCX.
  ///The function saves the PDF as a temporary file, converts it to DOCX format, and then downloads the resulting DOCX file.
  saveDOCX(pdf) async {
    /// Save the PDF as a temporary file
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/document.pdf");
    await file.writeAsBytes(await pdf.save());

    /// Convert the PDF to DOCX format
    String? filePath = await exportAsDOC(file);
    log(output.path);
    log(filePath ?? 'Hello');

    /// Download the converted DOCX file
    final request = await HttpClient().getUrl(Uri.parse(baseURL +
        filePath!
            .replaceFirst(".pdf", ".docx")
            .replaceFirst("PDF", "Doc")
            .replaceFirst('/', '')));
    final response = await request.close();
    final docfile = File("${output.path}/document.docx");
    response.pipe(docfile.openWrite());
    showSavedSnackbar(output.path, 'document.docx');
  }

  ///Displays a snackbar to notify the user about the saved document location.
  ///The [downloadLocation] parameter represents the path where the document is saved.
  ///The [filename] parameter represents the name of the saved file.
  ///The snackbar contains a message displaying the download location and an action button to open the downloaded file.
  showSavedSnackbar(String downloadLocation, filename) {
    SnackBar snackBar = SnackBar(
        content:
            Text(AppLocalizations.of(context).snack_location(downloadLocation)),
        action: SnackBarAction(
            label: AppLocalizations.of(context).snack_action,
            onPressed: () => OpenAppFile.open('$downloadLocation/$filename')));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ///Retrieves the theme data for the PDF document.
  ///The function loads custom fonts from the assets and creates a theme using those fonts.
  ///The theme data is used to style the generated PDF document.
  ///Returns the generated theme data.
  getTheme() async {
    var myTheme = pw.ThemeData.withFont(
        base: pw.Font.ttf(await rootBundle
            .load("assets/font/mandharam/mandharam_regular.ttf")),
        bold: pw.Font.ttf(
            await rootBundle.load("assets/font/mandharam/mandharam_bold.ttf")),
        italic: pw.Font.ttf(await rootBundle
            .load("assets/font/mandharam/mandharam_italic.ttf")),
        boldItalic: pw.Font.ttf(await rootBundle
            .load("assets/font/mandharam/mandharam_bold_italic.ttf")));
    return myTheme;
  }

  ///Saves the edited data.
  ///The [editedData] parameter represents the list of edited data to be saved.
  ///The function updates the annotatedText property of each SaveDataModel with the corresponding edited data.
  ///It then calls the postSaveData function to save the updated data.
  saveData(List<String> editedData) async {
    for (int i = 0; i < editedData.length; i++) {
      saveDatas[i].annotatedText = editedData[i];
    }
    await postSaveData(saveDatas);
  }

  ///Exports the document as PDF or DOCX.
  ///The function generates a PDF document using the provided theme data and the content from the Quill editor.
  ///It then calls the saveData function to save the edited data.
  ///Based on the selected export format (PDF or DOCX), it calls the corresponding savePDf or saveDOCX function.
  exportDoc() async {
    final pdf = pw.Document(
      theme: await getTheme(),
    );
    var delta = _controller.document.toDelta().toList();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          DeltaToPDF dpdf = DeltaToPDF();
          return dpdf.deltaToPDF(delta);
        }));
    await saveData(_controller.document.toPlainText().split(" "));
    if (isSelected[0]) {
      await savePDf(pdf);
    } else if (isSelected[1]) {
      await saveDOCX(pdf);
    }
  }

  ///Selects the file export type as PDF.
  ///Updates the state of the widget to set isSelected[0] to true and all other elements in isSelected to false.
  void selectFileExportType() {
    setState(() {
      isSelected = [for (var i = 0; i < isSelected.length; i++) false];
      isSelected[0] = true;
    });
  }

  ///Shows an alert dialog to select the file export type.
  ///The function displays an AlertDialog with a title, content, and actions.
  ///The content of the dialog contains a list of options (PDF and DOCX) as ListTile widgets.
  ///Each option can be selected by tapping on it, which updates the isSelected list accordingly.
  ///The selected option is indicated by a check icon.
  ///When the export button is pressed, the function calls the exportDoc function and closes the dialog.

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                      title: Text(AppLocalizations.of(context).title_export),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(AppLocalizations.of(context).save_the_doc),
                            // ListTile(
                            //     title: const Text('PDF'),
                            //     isThreeLine: false,
                            //     onTap: () {
                            //       setState(() {
                            //         isSelected = [
                            //           for (var i = 0;
                            //               i < isSelected.length;
                            //               i++)
                            //             false
                            //         ];
                            //         isSelected[0] = true;
                            //       });
                            //     },
                            //     trailing: isSelected[0]
                            //         ? const Icon(Icons.check,
                            //             color: Colors.green)
                            //         : const SizedBox()),
                            ListTile(
                                title: const Text('DOCX'),
                                isThreeLine: false,
                                onTap: () {
                                  setState(() {
                                    isSelected = [
                                      for (var i = 0;
                                          i < isSelected.length;
                                          i++)
                                        false
                                    ];
                                    isSelected[1] = true;
                                  });
                                },
                                trailing: isSelected[1]
                                    ? const Icon(Icons.check,
                                        color: Colors.green)
                                    : const SizedBox()),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                            child: Text(AppLocalizations.of(context)
                                .text_button_cancel),
                            onPressed: () => Navigator.of(context).pop()),
                        ElevatedButton(
                            child: Text(AppLocalizations.of(context)
                                .text_button_export),
                            onPressed: () {
                              exportDoc();
                              Navigator.of(context).pop();
                            })
                      ]));
        });
  }

  double? userRating;
  final TextEditingController _remarkController = TextEditingController();
  sendFeedback() async {
    if (userRating != null) {
      await postFeedBack(1, userRating, _remarkController.text);
    }
  }

  Future<void> _showFeedbackDialog() async {
    Future.delayed(
        const Duration(seconds: 5),
        () => showDialog<void>(
            context: context,
            barrierDismissible: true, // user must tap button!
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (context, setState) => AlertDialog(
                          title: Text(
                              AppLocalizations.of(context).feedback_title,
                              textAlign: TextAlign.start),
                          content: SingleChildScrollView(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(
                                    AppLocalizations.of(context).feedback_body),
                                h8,
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      RatingBar.builder(
                                          itemCount: 5,
                                          itemSize: 36,
                                          itemBuilder: (context, index) {
                                            switch (index) {
                                              case 0:
                                                return const Icon(
                                                  Icons
                                                      .sentiment_very_dissatisfied,
                                                  color: Colors.red,
                                                );
                                              case 1:
                                                return const Icon(
                                                  Icons.sentiment_dissatisfied,
                                                  color: Colors.redAccent,
                                                );
                                              case 2:
                                                return const Icon(
                                                  Icons.sentiment_neutral,
                                                  color: Colors.amber,
                                                );
                                              case 3:
                                                return const Icon(
                                                  Icons.sentiment_satisfied,
                                                  color: Colors.lightGreen,
                                                );
                                              case 4:
                                                return const Icon(
                                                  Icons
                                                      .sentiment_very_satisfied,
                                                  color: Colors.green,
                                                );
                                              default:
                                                return const Icon(
                                                  Icons.sentiment_satisfied,
                                                  color: Colors.lightGreen,
                                                );
                                            }
                                          },
                                          onRatingUpdate: (rating) {
                                            log(rating.toString());
                                            setState(() {
                                              userRating = rating;
                                            });
                                          })
                                    ]),
                                h16,
                                if (userRating != null) ...[
                                  Text(
                                      AppLocalizations.of(context).rating_title,
                                      textAlign: TextAlign.start),
                                  h8,
                                  TextFormField(
                                      minLines: 2,
                                      maxLines: 2,
                                      controller: _remarkController,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder()))
                                ]
                              ])),
                          actions: <Widget>[
                            TextButton(
                                child: Text(AppLocalizations.of(context)
                                    .text_button_cancel),
                                onPressed: () => Navigator.of(context).pop()),
                            ElevatedButton(
                                child: Text(AppLocalizations.of(context)
                                    .rating_button_send),
                                onPressed: () {
                                  sendFeedback();
                                  Navigator.of(context).pop();
                                })
                          ]));
            }));
  }

  ///Builds the UI for the ResulPage widget.
  ///The function returns a Scaffold widget with an AppBar and a body.
  ///The AppBar contains a title and an export button.
  ///The body consists of a Column widget with a QuillToolbar and a QuillEditor.
  ///The QuillToolbar is used to provide formatting options for the QuillEditor.
  ///The QuillEditor displays the rich text content and allows editing.
  ///Returns the built Scaffold widget.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context).appbar_result),
            actions: [
              TextButton(
                  onPressed: () async => _showAlertDialog(),
                  child: Text(AppLocalizations.of(context).appbar_export))
            ]),
        body: Column(children: [
          fq.QuillToolbar.basic(controller: _controller),
          Expanded(
              child: fq.QuillEditor.basic(
            controller: _controller,
            readOnly: false,
          ))
        ]));
  }
}
