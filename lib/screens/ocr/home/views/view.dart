import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:htr/api/ocr.dart';
import 'package:htr/config/assets/assets.dart';
import 'package:htr/models/upload_ocr.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;

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

    setState(() {
      isUploading = true;
    });
    if (result != null) {
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
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) =>
        //         EditingPage(ocr: ocr, quillController: _quillController)));
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
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    fileUploadOCRSVG,
                    const Text('Upload PDF or Image')
                  ])),
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FloatingActionButton.extended(
                label: const Text('Upload File'),
                icon: const Icon(Icons.upload_outlined),
                onPressed: () => uploadFile())),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }
}
