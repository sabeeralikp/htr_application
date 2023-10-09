import 'dart:io';

import 'package:delta_to_pdf/delta_to_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'package:htr/api/api.dart';
import 'package:htr/api/htr.dart';
import 'package:htr/api/ocr.dart';
import 'package:htr/config/buttons/button_themes.dart';
import 'package:htr/config/measures/gap.dart';
import 'package:htr/models/ocr_result.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdf/widgets.dart' as pw;

class OCRResult extends StatefulWidget {
  const OCRResult({super.key, required this.ocrResult});

  final OCRResultModel? ocrResult;

  @override
  State<OCRResult> createState() => _OCRResultState();
}

class _OCRResultState extends State<OCRResult> {
  getNextPage() async {
    if (widget.ocrResult!.ocr != null &&
        widget.ocrResult!.ocr!.numberOfPages! > 1) {
      for (int i = 1; i < widget.ocrResult!.ocr!.numberOfPages!; i++) {
        String? extractedText =
            await extractText(i, widget.ocrResult!.ocr!.id!);
        String text = widget.ocrResult!.quillController!.document.toPlainText();
        text += (extractedText ?? '');
        widget.ocrResult!.quillController!.clear();
        widget.ocrResult!.quillController!.document.insert(0, text);
      }
    }
  }

  showSavedSnackbar(String downloadLocation, filename) {
    SnackBar snackBar = SnackBar(
        content: Text('File has been downloaded to $downloadLocation'),
        action: SnackBarAction(
            label: 'Open',
            onPressed: () => OpenAppFile.open('$downloadLocation/$filename')));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  copyText() async {
    await Clipboard.setData(ClipboardData(
        text: widget.ocrResult!.quillController!.document.toPlainText()));
    setState(() {
      SnackBar snackBar = const SnackBar(
          content: Text("Text has successfully copied to the clipboard"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  saveDOCX(pdf) async {
    /// Save the PDF as a temporary file
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/document.pdf");
    await file.writeAsBytes(await pdf.save());

    /// Convert the PDF to DOCX format
    String? filePath = await exportAsDOC(file);

    /// Download the converted DOCX file
    final request = await HttpClient().getUrl(Uri.parse(baseURL +
        filePath!.replaceFirst(".pdf", ".docx").replaceFirst("PDF", "Doc")));
    final response = await request.close();
    final docfile = File("${output.path}/document.docx");
    response.pipe(docfile.openWrite());
    showSavedSnackbar(output.path, 'document.docx');
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

  exportDoc() async {
    final pdf = pw.Document(
      theme: await getTheme(),
    );
    var delta = widget.ocrResult!.quillController!.document.toDelta().toList();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          DeltaToPDF dpdf = DeltaToPDF();
          return dpdf.deltaToPDF(delta);
        }));

    await saveDOCX(pdf);
  }

  @override
  void initState() {
    super.initState();
    getNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Result'), actions: [
          CustomWhiteElevatedButton(
              onPressed: () async => copyText(),
              child: const Row(children: [
                Text("Copy All"),
                w8,
                Icon(Icons.copy_all_rounded)
              ])),
          w8,
          CustomWhiteElevatedButton(
              onPressed: () async => exportDoc(),
              child: Row(children: [
                Text(AppLocalizations.of(context)!.appbar_export),
                w8,
                const Icon(Icons.file_download_outlined)
              ])),
          w8
        ]),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (widget.ocrResult!.quillController != null) ...[
                fq.QuillToolbar.basic(
                    controller: widget.ocrResult!.quillController!),
                Expanded(
                    child: fq.QuillEditor.basic(
                        controller: widget.ocrResult!.quillController!,
                        readOnly: false))
              ]
            ])));
  }
}
