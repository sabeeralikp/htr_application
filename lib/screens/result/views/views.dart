import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;
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
  @override
  void initState() {
    super.initState();
    if (widget.args != null) {
      String words = "";
      for (var str in widget.args!) {
        words = "$words $str";
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
              fontSize = 24;
            } else if (value == 2) {
              fontWeight = pw.FontWeight.bold;
              fontSize = 20;
            } else {
              fontSize = 16;
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
    if (hasAttribute) {
      attribute!.forEach((key, value) {
        switch (key) {
          case "color":
            fontColor = PdfColor.fromHex(value);
            break;
        }
      });
    }
    return pw.Text(text,
        style: pw.TextStyle(
            color: fontColor,
            fontWeight: fontWeight,
            fontSize: fontSize,
            fontFallback: [pw.Font.symbol()]));
  }

  deltaToPDF(List<fq.Operation> deltaList) {
    List header = [null, null];
    List texts = [];
    List pdfColumnWidget = [];
    pw.FontWeight defaultWeight = pw.FontWeight.normal;
    for (var element in deltaList.reversed) {
      print(element.data);
      print(element.attributes);
      if (element.data == '\n') {
        if (header != [] && texts != []) {
          pdfColumnWidget = pdfColumnWidget +
              [
                pw.Row(
                    children: [...texts],
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start)
              ];
        }
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
          pw.Row(children: [...texts])
        ];
    return pw.Column(
        children: [...pdfColumnWidget.reversed],
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start);
  }

  savePDf(pdf) async {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());
    print(output.path);
  }

  getTheme() async {
    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load(
          "assets/font/Noto_Serif_Malayalam/static/NotoSerifMalayalam-Regular.ttf")),
      bold: pw.Font.ttf(await rootBundle.load(
          "assets/font/Noto_Serif_Malayalam/static/NotoSerifMalayalam-Bold.ttf")),
    );
    return myTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Result Page'),
          actions: [
            IconButton(
                onPressed: () async {
                  final pdf = pw.Document(
                    theme: await getTheme(),
                  );
                  var delta = _controller.document.toDelta().toList();
                  pdf.addPage(pw.Page(
                      pageFormat: PdfPageFormat.a4,
                      build: (pw.Context context) {
                        return deltaToPDF(delta);
                      }));
                  await savePDf(pdf);
                },
                icon: const Icon(Icons.download_for_offline_rounded))
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
