import 'dart:html';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:htr/api/ocr.dart';
import 'package:htr/config/buttons/custom_elevated_button.dart';
import 'package:htr/config/colors/colors.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/measures/gap.dart';
import 'package:htr/config/widgets/upload.dart';
import 'package:htr/models/ocr_result.dart';
import 'package:htr/models/upload_ocr.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'package:htr/routes/route.dart';
import 'package:ionicons/ionicons.dart';

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
        appBar: AppBar(title: Text('Printed', style: fMTG32SB)),
        body: isUploading
            ? const UploadingIndicator()
            : Center(
                child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    onTap: uploadFile,
                    child: DottedBorder(
                        borderType: BorderType.RRect,
                        color: kTextGreyColor.withOpacity(0.4),
                        dashPattern: const [10],
                        borderPadding: const EdgeInsets.all(2),
                        radius: const Radius.circular(16),
                        padding: const EdgeInsets.all(8),
                        strokeWidth: 2,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomElevatedButton(
                                      onPressed: uploadFile,
                                      child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('Choose a file'),
                                            w12,
                                            Icon(Ionicons.cloud_upload_outline)
                                          ])),
                                  h24,
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Text(
                                          "Please upload the document in either PDF format or as an image.",
                                          style: fTG16N,
                                          textAlign: TextAlign.center))
                                ]))))));
  }
}
