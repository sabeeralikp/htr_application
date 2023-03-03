import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:htr/api/htr.dart';
import 'package:htr/config/measures/padding.dart';
import 'package:htr/config/widgets/upload.dart';
import 'package:htr/models/htr.dart';
import 'package:htr/routes/route.dart';
import 'package:htr/screens/home/widgets/fab.dart';
import 'package:htr/screens/home/widgets/upload_file_body.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? file;
  HTRModel? htr;
  bool isUploading = false;
  FilePickerResult? result;

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
          htr = await uploadHTRWeb(fileBytes, fileName);
          isUploading = false;
          setState(() {});
          log(htr!.toString());
        }
      } else {
        file = File(result!.files.single.path!);
        if (file != null) {
          htr = await uploadHTR(file!);
          isUploading = false;
          setState(() {});
          log(htr.toString());
        }
      }
      navigateToResult();
    }
  }

  void navigateToResult() {
    if (htr != null) {
      Navigator.of(context).pushNamed(RouteProvider.result, arguments: htr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: x32,
        child: Center(
          child:
              isUploading ? const UploadingIndicator() : const UploadFileBody(),
        ),
      ),
      floatingActionButton: floatingActionButton(uploadFile),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
