import 'dart:developer';
// import 'dart:html' as html;
import 'dart:io';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'package:pdf/widgets.dart' as pw;
import 'package:htr/screens/result/widgets/widgets.dart';

class ResulPage extends StatefulWidget {
  final List<dynamic>? args;
  const ResulPage({this.args, super.key});

  @override
  State<ResulPage> createState() => _ResulPageState();
}

class _ResulPageState extends State<ResulPage> {
  final fq.QuillController _controller = fq.QuillController.basic();
  List<SaveDataModel> saveDatas = [];
  int selectedIndex = -1;
  List<bool> isSelected = [false, false];
  @override
  void initState() {
    super.initState();
    if (widget.args != null) {
      String words = "";
      for (int i = 0; i < widget.args!.length ~/ 2; i++) {
        words = "$words ${widget.args![i]}";
        log((widget.args![i + (widget.args!.length ~/ 2)]['id']).toString());
        log((widget.args![i]).toString());
        saveDatas.add(SaveDataModel(
            imageCordinate: widget.args![i + (widget.args!.length ~/ 2)]['id'],
            annotatedText: widget.args![i]));
      }
      _controller.document.insert(0, words.replaceFirst(" ", ""));
    }
  }

  savePDf(pdf) async {
    if (!kIsWeb) {
      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/document.pdf");
      await file.writeAsBytes(await pdf.save());
      log(output.path);
      showSavedSnackbar(output.path, 'document.pdf');
    } else {
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

  saveDOCX(pdf) async {
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/document.pdf");
    await file.writeAsBytes(await pdf.save());
    String? filePath = await exportAsDOC(file);
    log(output.path);
    log(filePath ?? 'Hello');
    final request = await HttpClient().getUrl(Uri.parse(baseURL +
        filePath!.replaceFirst(".pdf", ".docx").replaceFirst("PDF", "Doc")));
    final response = await request.close();
    final docfile = File("${output.path}/document.docx");
    response.pipe(docfile.openWrite());
    showSavedSnackbar(output.path, 'document.docx');
  }

  showSavedSnackbar(String downloadLocation, filename) {
    SnackBar snackBar = SnackBar(
        content:
            Text(AppLocalizations.of(context).snack_location(downloadLocation)),
        action: SnackBarAction(
            label: AppLocalizations.of(context).snack_action,
            onPressed: () => OpenAppFile.open('$downloadLocation/$filename')));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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

  saveData(List<String> editedData) async {
    for (int i = 0; i < editedData.length; i++) {
      saveDatas[i].annotatedText = editedData[i];
    }
    await postSaveData(saveDatas);
  }

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

  void selectFileExportType() {
    setState(() {
      isSelected = [for (var i = 0; i < isSelected.length; i++) false];
      isSelected[0] = true;
    });
  }

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
                            ListTile(
                                title: const Text('PDF'),
                                isThreeLine: false,
                                onTap: () {
                                  setState(() {
                                    isSelected = [
                                      for (var i = 0;
                                          i < isSelected.length;
                                          i++)
                                        false
                                    ];
                                    isSelected[0] = true;
                                  });
                                },
                                trailing: isSelected[0]
                                    ? const Icon(Icons.check,
                                        color: Colors.green)
                                    : const SizedBox()),
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
