// import 'dart:io';
import 'package:delta_to_pdf/delta_to_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'package:htr/api/api.dart';
import 'package:htr/api/htr.dart';
import 'package:htr/api/ocr.dart';
import 'package:htr/config/buttons/custom_elevated_button.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/measures/gap.dart';
import 'package:htr/models/ocr_result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

/// [Printed with OCR integrated]
/// [author] sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	(August 17th, 2023 12:32 PM)
///
/// Define a Flutter Stateful Widget for the OCR result screen.
class OCRResult extends StatefulWidget {
  // Constructor for the OCRResult widget.
  const OCRResult({super.key, required this.ocrResult});
// The OCRResultModel containing OCR results and Quill controller.
  final OCRResultModel? ocrResult;
// Create and return the state for the OCRResult widget.
  @override
  State<OCRResult> createState() => _OCRResultState();
}

// Define the state for the OCRResult widget.
class _OCRResultState extends State<OCRResult> {
  int i = 0;
  // Function to get the next page's text and append it to the Quill controller.
  getNextPage() async {
    if (widget.ocrResult!.ocr!.numberOfPages! > 1) {
      for (i = 1; i < widget.ocrResult!.ocr!.numberOfPages!; i++) {
        // Extract text from the page and append it to the existing text.
        String? extractedText =
            await extractText(i, widget.ocrResult!.ocr!.id!);
        String text = widget.ocrResult!.quillController!.document.toPlainText();
        text += (extractedText ?? '');
        // Clear the Quill controller and insert the updated text.
        widget.ocrResult!.quillController!.clear();
        widget.ocrResult!.quillController!.document.insert(0, text);
        setState(() {});
      }
    }
  }

  // Show a snackbar with a download location and file opening action.
  showSavedSnackbar(String downloadLocation, filename) {
    SnackBar snackBar = SnackBar(
        content: Text('File has been downloaded to $downloadLocation'),
        action: SnackBarAction(
            label: 'Open',
            onPressed: () => OpenAppFile.open('$downloadLocation/$filename')));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// Function to save a PDF document as a DOCX file.
  saveDOCX(pdf) async {
    /// Save the PDF as a temporary file

// Generate bytes from the PDF document.
    final bytes = await pdf.save();
    // final output = await getApplicationDocumentsDirectory();
    // final file = File("${output.path}/document.pdf");
    // await file.writeAsBytes(await pdf.save());

    /// Convert the PDF to DOCX format
    String? filePath = await exportAsDOCWeb(bytes, 'document.pdf');

    /// Download the converted DOCX file
    /// Create an anchor element for downloading the DOCX file.
    final anchor = html.AnchorElement()
      ..href = baseURL +
          filePath!.replaceFirst(".pdf", ".docx").replaceFirst("PDF", "Doc")
      ..style.display = 'none'
      ..download = 'document.docx';
    // Add the anchor element to the HTML body, trigger the download, and remove it.
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    // Revoke the object URL used for download.
    html.Url.revokeObjectUrl(baseURL +
        filePath.replaceFirst(".pdf", ".docx").replaceFirst("PDF", "Doc"));
    // final request = await HttpClient().getUrl(Uri.parse(baseURL +
    //     filePath!.replaceFirst(".pdf", ".docx").replaceFirst("PDF", "Doc")));
    // final response = await request.close();
    // final docfile = File("${output.path}/document.docx");
    // response.pipe(docfile.openWrite());
    // showSavedSnackbar(output.path, 'document.docx');
  }

// Function to get the PDF generation theme with custom fonts.
  getTheme() async {
    // Define the custom fonts for the PDF theme.
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

// Function to copy text to the clipboard.
  copyText() async {
    // Copy the text from the Quill controller to the clipboard.
    await Clipboard.setData(ClipboardData(
        text: widget.ocrResult!.quillController!.document.toPlainText()));
    setState(() {
      // Show a snackbar indicating successful text copying.
      SnackBar snackBar = SnackBar(
        content: Text(
            AppLocalizations.of(context)!.copy_to_clipboard_success_message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

// Function to export the document as a PDF.
  exportDoc() async {
    // Create a PDF document with custom theme.
    final pdf = pw.Document(
      theme: await getTheme(),
    );
    // Convert Quill Delta to PDF format and add it to the PDF document.
    var delta = widget.ocrResult!.quillController!.document.toDelta().toList();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          DeltaToPDF dpdf = DeltaToPDF();
          return dpdf.deltaToPDF(delta);
        }));
// Save the PDF as a DOCX file.
    await saveDOCX(pdf);
  }

// Initialize the state and call getNextPage function.
  @override
  void initState() {
    super.initState();
    getNextPage();
  }

// Build the widget tree for the OCR result screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text(AppLocalizations.of(context)!.appbar_result, style: fB20N),
            actions: [
              Padding(
                // Row with copy and export buttons.
                padding: const EdgeInsets.only(right: 48.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Button to copy text to the clipboard.
                    CustomWhiteElevatedButton(
                        onPressed: () async => copyText(),
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.copy_button),
                            w8,
                            const Icon(Icons.copy_all_rounded),
                          ],
                        )),
                    w16, // Horizontal spacing.
                    // Button to export the document as PDF.
                    CustomWhiteElevatedButton(
                        onPressed: () async => exportDoc(),
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.appbar_export),
                            w8,
                            const Icon(Icons.file_download_outlined),
                          ],
                        )),
                  ],
                ),
              )
            ],
            bottom: (i < widget.ocrResult!.ocr!.numberOfPages!)
                ? const PreferredSize(
                    preferredSize: Size(double.infinity, 16),
                    child: LinearProgressIndicator())
                : null),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // Display Quill toolbar and editor for editing text.
              if (widget.ocrResult!.ocr != null) ...[
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
