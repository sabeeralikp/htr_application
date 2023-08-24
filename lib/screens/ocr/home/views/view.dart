import 'dart:developer';

import 'package:htr/api/ocr.dart';
import 'package:htr/models/ocr_result.dart';
import 'package:htr/models/upload_ocr.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'package:htr/screens/htr/home/widgets/widgets.dart';

class OCRHome extends StatefulWidget {
  const OCRHome({super.key});

  @override
  State<OCRHome> createState() => _OCRHomeState();
}

class _OCRHomeState extends State<OCRHome> {
  FilePickerResult? result;
  File? file;
  UploadOCRModel? ocr;
  bool isUploading = false;
  TextEditingController extractedTextController = TextEditingController();
  final fq.QuillController _quillController = fq.QuillController.basic();
  Future<void> uploadFile() async {
    result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'jpeg', 'png']);
    if (result != null) {
      setState(() {
        isUploading = true;
      });
      if (kIsWeb) {
        Uint8List? fileBytes = result!.files.first.bytes;
        String fileName = result!.files.first.name;
        if (fileBytes != null) {
          ocr = await uploadOCRWeb(fileBytes, fileName);
          isUploading = false;
          setState(() {});
        }
      } else {
        file = File(result!.files.single.path!);
        if (file != null) {
          ocr = await uploadOCR(file!);
        }
      }
      setState(() {
        isUploading = false;
        extractedTextController.text =
            ocr != null ? ocr!.predictedText!.replaceAll('\n', ' ') : '';
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

  getCameraImage() async {
    if (mounted) {
      try {
        final XFile? capturedImage =
            await ImagePicker().pickImage(source: ImageSource.camera);
        if (capturedImage == null) return;
        file = File(capturedImage.path);
        if (file != null) {
          isUploading = true;
          ocr = await uploadOCR(file!);
          setState(() {
            extractedTextController.text =
                ocr != null ? ocr!.predictedText!.replaceAll('\n', ' ') : '';
            _quillController.clear();
            _quillController.document
                .insert(0, ocr != null ? ocr!.predictedText : '');
            OCRResultModel ocrResult =
                OCRResultModel(ocr: ocr, quillController: _quillController);
            Navigator.of(context)
                .pushNamed(RouteProvider.ocrresult, arguments: ocrResult)
                .whenComplete(() => setState(() {
                      isUploading = false;
                    }));
          });
        }
      } on Exception catch (e) {
        log('Failed to pick image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Printed'),
        ),
        body: isUploading
            ? const UploadingIndicator()
            : const UploadFileBody(isOCR: true),
        floatingActionButton: Row(mainAxisSize: MainAxisSize.min, children: [
          FloatingActionButton.extended(
              heroTag: "Upload File",
              label:
                  Text(AppLocalizations.of(context).upload_fab, style: fW16M),
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
