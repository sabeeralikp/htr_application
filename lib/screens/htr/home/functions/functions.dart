import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:htr/api/htr.dart';
import 'package:htr/models/upload_htr.dart';
import 'package:htr/routes/route.dart';
import 'package:htr/screens/htr/home/home.dart';
import 'package:image_picker/image_picker.dart';

///
/// [author]	Sabeerali
/// [since]	v0.0.1 
/// [version]	v1.0.0	(July 3rd, 2023 11:09 AM)
/// [see]		function

/// A class that contains functions related to the home screen functionality.
class HomeFunctions {
  /// The selected file to be uploaded.
  File? file;
  /// The model representing the HTR (Handwritten Text Recognition) result.
  UploadHTRModel? htr;
  /// A flag indicating whether a file upload is in progress.
  bool isUploading = false;
  /// The result of the file picker.
  FilePickerResult? result;
  /// The selected segmentation mode.
  Segmentation selectedSegment = Segmentation.auto;
/// Uploads a file and updates the UI state using the provided [setState] function.
  Future<void> uploadFile(setState) async {
    result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'jpeg', 'png']);
    if (result != null) {
      isUploading = true;
      if (kIsWeb) {
        Uint8List? fileBytes = result!.files.first.bytes;
        String fileName = result!.files.first.name;
        if (fileBytes != null) {
          htr = await uploadHTRWeb(fileBytes, fileName);
          isUploading = false;
        }
      } else {
        file = File(result!.files.single.path!);
        if (file != null) {
          htr = await uploadHTR(file!);
          isUploading = false;
        }
      }
      setState(() {});
    }
  }
/// Navigates to the result screen with the selected HTR result.
  void navigateToResult(context) {
    if (htr != null) {
      htr!.segment = selectedSegment.name;
      Navigator.of(context).pushNamed(RouteProvider.segment, arguments: htr);
    }
  }
/// Captures an image from the device's camera and processes it using HTR.
  getCameraImage(mounted, setState) async {
    if (mounted) {
      try {
        final XFile? capturedImage =
            await ImagePicker().pickImage(source: ImageSource.camera);
        if (capturedImage == null) return;
        file = File(capturedImage.path);
        if (file != null) {
          htr = await uploadHTR(file!);
          isUploading = false;
          setState(() {});
        }
      } on Exception catch (e) {
        log('Failed to pick image: $e');
      }
    }
  }
/// Removes the HTR result from the state.
  void removeHTR(setState) {
    setState(() {
      htr = null;
    });
  }
/// Handles the selection of a segmentation mode and updates the state.
  void segmentOnClick(Set<Segmentation> newSelection, setState) {
    setState(() {
      selectedSegment = newSelection.first;
    });
  }
}
