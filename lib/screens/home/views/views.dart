import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:htr/api/htr.dart';
import 'package:htr/config/assets/assets.dart';
import 'package:htr/config/colors/colors.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/measures/padding.dart';
import 'package:htr/config/widgets/upload.dart';
import 'package:htr/models/upload_htr.dart';
import 'package:htr/routes/route.dart';
import 'package:htr/screens/home/widgets/upload_file_body.dart';
import 'package:image_picker/image_picker.dart';
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

  getCameraImage() async {
    try {
      final XFile? capturedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (capturedImage == null) return;
      file = File(capturedImage.path);
      if (file != null) {
        htr = await uploadHTR(file!);
        isUploading = false;
        setState(() {});
        log(htr.toString());
      }
    } on Exception catch (e) {
      log('Failed to pick image: $e');
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
                                      leading: SizedBox(
                                          width: 48,
                                          height: 48,
                                          child: pdfFile),
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
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50)),
                                            border: Border.all(
                                                color: Colors.red, width: 0.75),
                                            color: const Color.fromARGB(
                                                80, 244, 67, 54),
                                          ),
                                          child: const Icon(
                                            Icons.close_rounded,
                                            size: 18,
                                            color: Colors.red,
                                          ),
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
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.extended(
                  label: Text('Upload', style: w16M),
                  icon: cloudUploadIcon,
                  onPressed: uploadFile,
                ),
                const SizedBox(
                  width: 8,
                ),
                if (Platform.isAndroid || Platform.isIOS)
                  FloatingActionButton(
                      onPressed: () {
                        getCameraImage();
                      },
                      child: const Icon(Icons.camera_alt_rounded,
                          color: Colors.white))
              ],
            )
          : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
