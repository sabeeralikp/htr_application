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
/// [integrating OCR to HTR]
/// [author] sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	(August 17th, 2023 10:18 AM) 
///
// Define a Flutter Stateful Widget for the OCR Home screen.
class OCRHome extends StatefulWidget {
  // Constructor for the OCRHome widget.
  const OCRHome({super.key});
// Create and return the state for the OCRHome widget.
  @override
  State<OCRHome> createState() => _OCRHomeState();
}
// Define the state for the OCRHome widget.
class _OCRHomeState extends State<OCRHome> {
  // Variables for handling file upload and OCR processing.
  FilePickerResult? result; // Stores the result of file picking.
  File? file;               // Stores the selected file.
  UploadOCRModel? ocr;      // Stores the OCR result.
  bool isUploading = false; // Indicates if a file is being uploaded.
  // A controller for handling extracted text input.
  TextEditingController extractedTextController = TextEditingController();
  // Create a Quill controller for rich text editing.
  final fq.QuillController _quillController = fq.QuillController.basic();
  // Function for uploading a selected file.
  Future<void> uploadFile() async {
    // Pick a file with specific allowed extensions.
    result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'jpeg', 'png']);
    if (result != null) {
      // Set isUploading to true to indicate file upload in progress.
      setState(() {
        isUploading = true;
      });
      if (kIsWeb) {
        // If running on the web, extract file bytes and name.
        Uint8List? fileBytes = result!.files.first.bytes;
        String fileName = result!.files.first.name;
        if (fileBytes != null) {
          // Upload the file for OCR processing.
          ocr = await uploadOCRWeb(fileBytes, fileName);
          // File upload is complete, set isUploading to false and trigger UI update.
          isUploading = false;
          setState(() {});
        }
      }
      // Handle the completion of file upload and navigation to OCR result screen.
      setState(() {
        // Set isUploading to false to indicate file upload is complete.
        isUploading = false;
        // Update the extracted text controller with OCR results (if available).
        extractedTextController.text =
            ocr != null ? ocr!.predictedText!.replaceAll('\n', ' ') : '';
        // Clear the Quill controller and insert OCR text (if available).
        _quillController.clear();
        _quillController.document
            .insert(0, ocr != null ? ocr!.predictedText : '');
        // Create an OCRResultModel with OCR and Quill controller for navigation arguments.    
        OCRResultModel ocrResult =
            OCRResultModel(ocr: ocr, quillController: _quillController);
        // Navigate to the OCR result screen with the OCR result as arguments.
        Navigator.of(context)
            .pushNamed(RouteProvider.ocrresult, arguments: ocrResult);
      });
    }
  }
// Build the widget tree for the OCR home screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Printed', style: fMTG32SB)),// Set the app bar title.
        body: isUploading
            ? const UploadingIndicator() // Show an uploading indicator if a file is being uploaded.
            : Center(
              // Create an InkWell widget for the file upload action.
                child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    onTap: uploadFile, // Trigger file upload on tap.
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
                                  // Custom elevated button for file selection.
                                  CustomElevatedButton(
                                      onPressed: uploadFile,// Trigger the file upload function on button press.
                                      child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('Choose a file'),
                                            w12,
                                            Icon(Ionicons.cloud_upload_outline)
                                          ])),
                                  h24,// Vertical spacing.
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Text(
                                          "Please upload the document in either PDF format or as an image.",
                                          style: fTG16N,// Apply a specific text style.
                                          textAlign: TextAlign.center))// Center-align the text.
                                ]))))));
  }
}
