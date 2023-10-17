import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dhriti/api/htr.dart';
import 'package:dhriti/models/upload_htr.dart';
import 'package:dhriti/routes/route.dart';
import 'package:dhriti/screens/htr/home/home.dart';
import 'package:image_picker/image_picker.dart';

class HomeFunctions {
  File? file;
  UploadHTRModel? htr;
  bool isUploading = false;
  FilePickerResult? result;
  Segmentation selectedSegment = Segmentation.auto;

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

  void navigateToResult(context) {
    if (htr != null) {
      htr!.segment = selectedSegment.name;
      Navigator.of(context).pushNamed(RouteProvider.segment, arguments: htr);
    }
  }

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

  void removeHTR(setState) {
    setState(() {
      htr = null;
    });
  }

  void segmentOnClick(Set<Segmentation> newSelection, setState) {
    setState(() {
      selectedSegment = newSelection.first;
    });
  }
}
