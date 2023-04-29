import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:htr/api/htr.dart';
import 'package:htr/config/assets/assets.dart';
import 'package:htr/config/colors/colors.dart';
import 'package:htr/config/measures/padding.dart';
import 'package:htr/config/widgets/upload.dart';
import 'package:htr/models/upload_htr.dart';
import 'package:htr/routes/route.dart';
import 'package:htr/screens/home/widgets/fab.dart';
import 'package:htr/screens/home/widgets/upload_file_body.dart';
import 'package:timeago/timeago.dart' as timeago;

enum Segmentation { manual, auto }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? file;
  UploadHTRModel? htr;
  bool isUploading = false;
  FilePickerResult? result;
  Segmentation selectedSegment = Segmentation.auto;

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
      // navigateToResult();
    }
  }

  void navigateToResult() {
    if (htr != null) {
      htr!.segment = selectedSegment.name;
      Navigator.of(context).pushNamed(RouteProvider.segment, arguments: htr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: x32,
        child: Center(
          child: isUploading
              ? const UploadingIndicator()
              : htr == null
                  ? const UploadFileBody()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Choose Segmentation Method',
                                  style: GoogleFonts.inter(
                                      color: kWhiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: kWhiteColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                width: 250,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                          Icons.file_present_outlined,
                                          color: kPrimaryColor),
                                      visualDensity: const VisualDensity(
                                          horizontal: -4, vertical: -4),
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        htr!.filename!,
                                        style: const TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Text(
                                        timeago.format(
                                            DateTime.parse(htr!.uploadedOn!)),
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      trailing: InkWell(
                                        onTap: () {
                                          setState(() {
                                            htr = null;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              SegmentedButton<Segmentation>(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              kWhiteColor),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              kPrimaryColor)),
                                  segments: const <ButtonSegment<Segmentation>>[
                                    ButtonSegment<Segmentation>(
                                        value: Segmentation.manual,
                                        label: Text('Manual'),
                                        icon: Icon(Icons.tune_rounded)),
                                    ButtonSegment<Segmentation>(
                                        value: Segmentation.auto,
                                        label: Text('Automatic'),
                                        icon: Icon(Icons.auto_awesome)),
                                  ],
                                  selected: <Segmentation>{selectedSegment},
                                  onSelectionChanged:
                                      (Set<Segmentation> newSelection) {
                                    setState(() {
                                      selectedSegment = newSelection.first;
                                    });
                                  }),
                              const SizedBox(height: 48),
                              ElevatedButton(
                                  onPressed: () {
                                    navigateToResult();
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              kWhiteColor),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              kPrimaryColor)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text('Continue'),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ),
      floatingActionButton: htr == null
          ? floatingActionButton(uploadFile, 'Upload', cloudUploadIcon)
          : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
