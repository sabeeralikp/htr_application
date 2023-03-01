import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:htr/api/htr.dart';
import 'package:htr/config/assets/assets.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/measures/gap.dart';
import 'package:htr/config/measures/padding.dart';
import 'package:htr/config/widgets/upload.dart';
import 'package:htr/models/htr.dart';
import 'package:htr/routes/route.dart';

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
      appBar: AppBar(),
      body: Padding(
        padding: x32,
        child: Center(
          child: isUploading
              ? const UploadingIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    fileUploadSVG,
                    h18,
                    Text('UPLOAD FILE', style: p16SB),
                    h4,
                    Text('Upload your pdf or image', style: p7014L),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Upload', style: w16M),
        icon: cloudUploadIcon,
        onPressed: uploadFile,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
