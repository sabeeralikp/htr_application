import 'dart:developer';
// import 'dart:html' as html;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'package:htr/api/api.dart';
import 'package:htr/api/htr.dart';
import 'package:htr/models/save_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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

  getPDFHeaderStyle(key, value) {
    pw.FontWeight fontWeight = pw.FontWeight.normal;
    double fontSize = 14;
    if (value == 1) {
      fontWeight = pw.FontWeight.bold;
      fontSize = 24;
    } else if (value == 2) {
      fontWeight = pw.FontWeight.bold;
      fontSize = 20;
    } else {
      fontWeight = pw.FontWeight.bold;
      fontSize = 16;
    }
    return [fontWeight, fontSize];
  }

  getHeaderAttributedText(
      Map<String, dynamic>? attribute, String text, bool hasAttribute) {
    pw.FontWeight fontWeight = pw.FontWeight.normal;
    double fontSize = 14;
    if (hasAttribute) {
      attribute!.forEach((key, value) {
        switch (key) {
          case "header":
            if (value == 1) {
              fontWeight = pw.FontWeight.bold;
              fontSize = 18;
            } else if (value == 2) {
              fontWeight = pw.FontWeight.bold;
              fontSize = 16;
            } else {
              fontWeight = pw.FontWeight.bold;
              fontSize = 12;
            }
            break;
        }
      });
    }
    return [fontWeight, fontSize];
  }

  getAttributedText(Map<String, dynamic>? attribute, String text,
      bool hasAttribute, pw.FontWeight fontWeight, double fontSize) {
    PdfColor fontColor = PdfColor.fromHex("#000");
    pw.FontStyle fontStyle = pw.FontStyle.normal;
    pw.TextDecoration decoration = pw.TextDecoration.none;
    pw.BoxDecoration boxDecoration = const pw.BoxDecoration();
    if (hasAttribute) {
      attribute!.forEach((key, value) {
        switch (key) {
          case "color":
            fontColor = PdfColor.fromHex(value);
            break;
          case "bold":
            fontWeight = pw.FontWeight.bold;
            break;
          case "italic":
            fontStyle = pw.FontStyle.italic;
            break;
          case "underline":
            decoration = pw.TextDecoration.underline;
            break;
          case "strike":
            decoration = pw.TextDecoration.lineThrough;
            break;
          case "background":
            boxDecoration = pw.BoxDecoration(color: PdfColor.fromHex(value));
        }
      });
    }
    return pw.Text(text,
        style: pw.TextStyle(
            color: fontColor,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            fontSize: fontSize,
            decoration: decoration,
            background: boxDecoration,
            fontFallback: [pw.Font.symbol()]));
  }

  deltaToPDF(List<fq.Operation> deltaList) {
    List header = [null, null];
    List texts = [];
    List pdfColumnWidget = [];
    for (var element in deltaList.reversed) {
      if (element.data == '\n') {
        if (header != [] && texts != []) {
          pdfColumnWidget = pdfColumnWidget +
              [
                pw.Row(
                    children: [...texts.reversed],
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start)
              ];
        }
        texts = [];
        header = getHeaderAttributedText(element.attributes,
            element.data.toString(), element.attributes != null);
      } else {
        texts.add(getAttributedText(
            element.attributes,
            element.data.toString(),
            element.attributes != null,
            header[0] ?? pw.FontWeight.normal,
            header[1] ?? 14));
      }
    }
    pdfColumnWidget = pdfColumnWidget +
        [
          pw.Row(children: [...texts.reversed])
        ];
    return pw.Column(
        children: [...pdfColumnWidget.reversed],
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start);
  }

  savePDf(pdf) async {
    if (!kIsWeb) {
      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/document.pdf");
      await file.writeAsBytes(await pdf.save());
      log(output.path);
      showSavedSnackbar(output.path);
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
    showSavedSnackbar(output.path);
  }

  showSavedSnackbar(String downloadLocation) {
    SnackBar snackBar = SnackBar(
      content:
          Text('The File has been downloaded and saved to $downloadLocation'),
    );
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
          return deltaToPDF(delta);
        }));
    await saveData(_controller.document.toPlainText().split(" "));
    if (isSelected[0]) {
      await savePDf(pdf);
    } else if (isSelected[1]) {
      await saveDOCX(pdf);
    }
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Export As'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text('Save the document as'),
                  ListTile(
                      title: const Text('PDF'),
                      isThreeLine: false,
                      onTap: () {
                        setState(() {
                          isSelected = [
                            for (var i = 0; i < isSelected.length; i++) false
                          ];
                          isSelected[0] = true;
                        });
                      },
                      trailing: isSelected[0]
                          ? const Icon(Icons.check, color: Colors.green)
                          : const SizedBox()),
                  ListTile(
                      title: const Text('DOCX'),
                      isThreeLine: false,
                      onTap: () {
                        setState(() {
                          isSelected = [
                            for (var i = 0; i < isSelected.length; i++) false
                          ];
                          isSelected[1] = true;
                        });
                      },
                      trailing: isSelected[1]
                          ? const Icon(Icons.check, color: Colors.green)
                          : const SizedBox()),
                  // ExportElement(itemName: 'PDF'),
                  // ExportElement(itemName: 'DOCX'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Export'),
                onPressed: () {
                  exportDoc();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Result Page'),
          actions: [
            TextButton(
                onPressed: () async {
                  _showAlertDialog();
                },
                child: const Text("Export As"))
          ],
        ),
        body: Column(
          children: [
            fq.QuillToolbar.basic(controller: _controller),
            Expanded(
              child: fq.QuillEditor.basic(
                controller: _controller,
                readOnly: false, // true for view only mode
              ),
            )
          ],
        ));
  }
}

class ExportElement extends StatefulWidget {
  final String itemName;
  const ExportElement({
    super.key,
    required this.itemName,
  });

  @override
  State<ExportElement> createState() => _ExportElementState();
}

class _ExportElementState extends State<ExportElement> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(widget.itemName),
        isThreeLine: false,
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
        },
        trailing: isSelected
            ? const Icon(Icons.check, color: Colors.green)
            : const SizedBox());
  }
}
