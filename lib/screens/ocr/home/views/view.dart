import 'dart:developer';

import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:dhriti/api/ocr.dart';
import 'package:dhriti/models/ocr_result.dart';
import 'package:dhriti/models/upload_ocr.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'package:dhriti/screens/htr/home/widgets/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class OCRHome extends StatefulWidget {
  final bool isOffline;
  const OCRHome({required this.isOffline, super.key});

  @override
  State<OCRHome> createState() => _OCRHomeState();
}

class _OCRHomeState extends State<OCRHome> {
  FilePickerResult? result;
  File? file;
  UploadOCRModel? ocr;
  bool isUploading = false;
  final fq.QuillController _quillController = fq.QuillController.basic();
  String language = "mal+eng";
  List<DropdownMenuItem<dynamic>>? languages = [
    const DropdownMenuItem(
        value: "mal+eng",
        child: SizedBox(width: 80, child: Text('English & Malayalam'))),
    const DropdownMenuItem(value: "mal", child: Text('Malayalam')),
    const DropdownMenuItem(value: "eng", child: Text('English'))
  ];
  extractOffline(String path) async {
    String text = "";
    if (path.endsWith('.pdf')) {
      PdfDocument pdfDocument = await PdfDocument.openFile(path);
      for (int i = 1; i <= pdfDocument.pagesCount; i++) {
        PdfPage pdfPage = await pdfDocument.getPage(i);
        PdfPageImage? pdfImage = await pdfPage.render(
            width: pdfPage.width,
            forPrint: true,
            height: pdfPage.height,
            format: PdfPageImageFormat.jpeg);
        final tempDir = await getTemporaryDirectory();
        File file = await File('${tempDir.path}/image.jpeg').create();
        await file.writeAsBytes(pdfImage!.bytes);
        text += await FlutterTesseractOcr.extractText(
            '${tempDir.path}/image.jpeg',
            language: language);

        pdfPage.close();
      }
      pdfDocument.close();
      log(text);
    } else {
      text = await FlutterTesseractOcr.extractText(path, language: language);

      log(text);
    }
    return text;
  }

  Future<void> uploadFile() async {
    result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'jpeg', 'png']);
    if (result != null) {
      setState(() {
        isUploading = true;
      });

      if (widget.isOffline) {
        String text = await extractOffline(result!.files.first.path ?? "");
        setState(() {
          _quillController.clear();
          _quillController.document.insert(0, text);
          isUploading = false;
          OCRResultModel ocrResult =
              OCRResultModel(ocr: ocr, quillController: _quillController);
          Navigator.of(context)
              .pushNamed(RouteProvider.ocrresult, arguments: ocrResult);
        });
      } else {
        file = File(result!.files.single.path!);
        if (file != null) {
          ocr = await uploadOCR(file!);
          setState(() {
            _quillController.clear();
            _quillController.document
                .insert(0, ocr != null ? ocr!.predictedText : '');
            isUploading = false;
            OCRResultModel ocrResult =
                OCRResultModel(ocr: ocr, quillController: _quillController);
            Navigator.of(context)
                .pushNamed(RouteProvider.ocrresult, arguments: ocrResult);
          });
        }
      }
    }
  }

  getCameraImage() async {
    if (mounted) {
      try {
        final XFile? capturedImage =
            await ImagePicker().pickImage(source: ImageSource.camera);
        if (capturedImage == null) return;
        file = File(capturedImage.path);
        if (file != null) {
          setState(() {
            isUploading = true;
          });
          if (widget.isOffline) {
            String text = await extractOffline(capturedImage.path);
            setState(() {
              isUploading = false;
              _quillController.clear();
              _quillController.document.insert(0, text);
              OCRResultModel ocrResult =
                  OCRResultModel(ocr: ocr, quillController: _quillController);
              Navigator.of(context)
                  .pushNamed(RouteProvider.ocrresult, arguments: ocrResult);
            });
          } else {
            ocr = await uploadOCR(file!);
            setState(() {
              isUploading = false;
              _quillController.clear();
              _quillController.document
                  .insert(0, ocr != null ? ocr!.predictedText : '');
              OCRResultModel ocrResult =
                  OCRResultModel(ocr: ocr, quillController: _quillController);
              Navigator.of(context)
                  .pushNamed(RouteProvider.ocrresult, arguments: ocrResult);
            });
          }
        }
      } on Exception catch (e) {
        log('Failed to pick image: $e');
      }
    }
  }

  void changeLanguage(selectedLanguage) {
    // log(selectedLanguage);
    setState(() {
      language = selectedLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Digital${widget.isOffline ? " (offline)" : ""}'),
          actions: widget.isOffline
              ? [
                  SizedBox(
                    width: 116,
                    child: DropdownButtonFormField(
                      items: languages,
                      value: language,
                      onChanged: changeLanguage,
                      decoration: const InputDecoration(
                          labelText: "Language",
                          contentPadding: EdgeInsets.only(left: 12),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  w8,
                ]
              : null,
        ),
        body: isUploading
            ? const UploadingIndicator()
            : const UploadFileBody(isOCR: true),
        floatingActionButton: Row(mainAxisSize: MainAxisSize.min, children: [
          FloatingActionButton.extended(
              heroTag: "Upload File",
              label:
                  Text(AppLocalizations.of(context)!.upload_fab, style: fW16M),
              icon: cloudUploadIcon,
              onPressed: uploadFile),
          w8,
          if (Platform.isAndroid || Platform.isIOS)
            FloatingActionButton(
                heroTag: "Camera Image",
                onPressed: getCameraImage,
                child: iCamera)
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
