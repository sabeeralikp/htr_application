import 'dart:developer';
import 'package:dhriti/screens/htr/home/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

/// An enumeration representing different types of segmentation.
///
/// The [Segmentation] enum defines two values: [manual] and [auto].
/// - [manual]: Represents manual segmentation.
/// - [auto]: Represents automatic segmentation.
enum Segmentation { manual, auto }

///
/// [HTRHome]
///
/// [author] sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	March 1st, 2023 1:14 PM
/// [see]		StatefulWidget
///
/// The home screen widget that manages the state.
///
/// Returns a widget representing the home screen.
class HTRHome extends StatefulWidget {
  const HTRHome({super.key});

  @override
  State<HTRHome> createState() => _HTRHomeState();
}

class _HTRHomeState extends State<HTRHome> {
  File? file;
  UploadHTRModel? htr;
  bool isUploading = false;
  FilePickerResult? result;
  Segmentation selectedSegment = Segmentation.auto;

  /// Handles the file upload process.
  ///
  /// This method is an asynchronous function that allows the user to select
  /// a file using the file picker. It sets the `result` variable to the picked file,
  /// sets `isUploading` to true, and updates the UI using [setState].
  /// If the platform is web, it extracts the file bytes and file name,
  /// and uploads the file using the `uploadHTRWeb` function.
  /// If the platform is not web, it assigns the picked file to the `file` variable
  /// and uploads the file using the `uploadHTR` function.
  ///
  /// Returns void.

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
        }
      } else {
        file = File(result!.files.single.path!);
        if (file != null) {
          htr = await uploadHTR(file!);
          isUploading = false;
          setState(() {});
        }
      }
    }
  }

  /// Navigates to the result screen.
  ///
  /// This method is called to navigate to the result screen
  /// if [htr] is not null. It sets the [segment] property of [htr]
  /// to the name of the selected segment and pushes the result screen
  /// route using the [Navigator] with the [RouteProvider.segment] route name
  /// and [htr] as the arguments.
  ///
  /// Returns void.
  void navigateToResult() {
    if (htr != null) {
      htr!.segment = selectedSegment.name;
      Navigator.of(context).pushNamed(RouteProvider.segment, arguments: htr);
    }
  }

  /// Retrieves an image from the camera and performs the HTR process.
  ///
  /// This asynchronous method is called to capture an image using the device's camera.
  /// If the widget is mounted, it uses the [ImagePicker] to pick an image from the camera
  /// and assigns it to [capturedImage]. If [capturedImage] is null, the method returns.
  /// The picked image is assigned to the [file] variable as a [File] object.
  /// If [file] is not null, the [uploadHTR] function is called to perform the HTR process,
  /// assigning the result to [htr]. [isUploading] is set to false, and the UI is updated using [setState].
  /// If any exception occurs during the process, an error message is logged.
  ///
  /// Returns void.

  getCameraImage() async {
    if (mounted) {
      try {
        final XFile? capturedImage = await ImagePicker().pickImage(
            source: ImageSource.camera,
            preferredCameraDevice: CameraDevice.rear);
        if (capturedImage == null) return;
        final croppedImage =
            await ImageCropper().cropImage(sourcePath: capturedImage.path);
        if (croppedImage == null) return;
        file = File(croppedImage.path);
        // file = await FlutterExifRotation.rotateImage(path: capturedImage.path);
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

  /// Removes the HTR result.
  ///
  /// This method is called to remove the HTR result by setting [htr] to null.
  /// The UI is updated using [setState].
  ///
  /// Returns void.

  void removeHTR() {
    setState(() {
      htr = null;
    });
  }

  /// Updates the selected segment.
  ///
  /// This method is called when a segment is clicked in the segmented button.
  /// It takes a [Set] of [Segmentation] as [newSelection], extracts the first segment
  /// from the set, and updates the [selectedSegment] with the extracted segment.
  /// The UI is updated using [setState].
  ///
  /// Returns void.
  void segmentOnClick(Set<Segmentation> newSelection) {
    setState(() {
      selectedSegment = newSelection.first;
    });
  }

  /// Builds the home screen widget.
  ///
  /// This method overrides the [build] method from the [StatefulWidget] class.
  /// It constructs and returns the home screen widget, which includes the app bar,
  /// the body content (either an uploading indicator, upload file body, or the result),
  /// and the floating action button (either the upload and camera buttons or an empty container).
  ///
  /// Returns a [Scaffold] widget.
//TODO: Description about auto and manual buttons
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.menu_title_2),
          // actions: [
          //   TextButton(
          //       onPressed: () => {
          //             Provider.of<LocaleProvider>(context, listen: false)
          //                 .changeLocale()
          //           },
          //       child: Row(children: [
          //         const Icon(Icons.translate_rounded),
          //         w8,
          //         Text(Provider.of<LocaleProvider>(context, listen: false)
          //                     .locale ==
          //                 AppLocalizations.supportedLocales[0]
          //             ? 'മലയാളം'
          //             : 'English')
          //       ]))
          // ],
        ),
        body: Padding(
            padding: pX32,
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
                                    padding: pA32,
                                    decoration: bDP16,
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              AppLocalizations.of(context)!
                                                  .file_uploaded_title,
                                              style: fW16N),
                                          h16,
                                          UploadedFileContainer(
                                              htr: htr!, removeHTR: removeHTR),
                                          h16,
                                          SegmentedButton<Segmentation>(
                                              style: wPButtonStyle,
                                              segments: <ButtonSegment<
                                                  Segmentation>>[
                                                ButtonSegment<Segmentation>(
                                                    value: Segmentation.manual,
                                                    label: Text(AppLocalizations
                                                            .of(context)!
                                                        .segmentation_button_manual),
                                                    icon: const Icon(
                                                        Icons.tune_rounded)),
                                                ButtonSegment<Segmentation>(
                                                    value: Segmentation.auto,
                                                    label: Text(AppLocalizations
                                                            .of(context)!
                                                        .segmentation_button_auto),
                                                    icon: const Icon(
                                                        Icons.auto_awesome))
                                              ],
                                              selected: <Segmentation>{
                                                selectedSegment
                                              },
                                              onSelectionChanged:
                                                  segmentOnClick),
                                          h48,
                                          ElevatedButton(
                                              onPressed: navigateToResult,
                                              style: wPButtonStyle,
                                              child: Padding(
                                                  padding: pA16,
                                                  child: Text(AppLocalizations
                                                          .of(context)!
                                                      .segmentation_button_cont)))
                                        ]))
                              ]))),

        /// Builds the floating action button.
        ///
        /// This code block conditionally renders the floating action button based on the value of [htr].
        /// If [htr] is null, it displays a row with an extended floating action button for uploading a file,
        /// and a small gap, followed by a floating action button for capturing an image from the camera
        /// (if the platform is Android or iOS). If [htr] is not null, an empty [SizedBox] is displayed.
        ///
        /// Returns a [Row] widget containing the floating action buttons, or a [SizedBox] widget if [htr] is not null.
        floatingActionButton: htr == null
            ? Row(mainAxisSize: MainAxisSize.min, children: [
                FloatingActionButton.extended(
                    heroTag: "Upload File",
                    label: Text(AppLocalizations.of(context)!.upload_fab,
                        style: fW16M),
                    icon: cloudUploadIcon,
                    onPressed: uploadFile),
                w8,
                if (Platform.isAndroid || Platform.isIOS)
                  FloatingActionButton(
                      heroTag: "Camera Image",
                      onPressed: getCameraImage,
                      child: iCamera)
              ])
            : const SizedBox(),

        /// Specifies the position of the floating action button.
        ///
        /// The floating action button is positioned at the center bottom of the screen.
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
