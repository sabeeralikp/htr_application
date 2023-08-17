import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:htr/api/ocr.dart';
import 'package:htr/config/assets/assets.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/widgets/upload.dart';
import 'package:htr/config/widgets/upload_file_body.dart';
import 'package:htr/models/ocr_result.dart';
import 'package:htr/models/upload_ocr.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'package:htr/routes/route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
