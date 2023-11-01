import 'package:htr/api/ocr.dart';
import 'package:htr/config/buttons/custom_elevated_button.dart';
import 'package:htr/config/colors/colors.dart';
import 'package:htr/models/ocr_result.dart';
import 'package:htr/models/upload_ocr.dart';
import 'package:htr/screens/htr/home/widgets/widgets.dart';
import 'package:ionicons/ionicons.dart';
export 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'dart:html' as html;

///
/// [Home Menu Added]
///
/// [author] Sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	(August 16th, 2023 3:27 PM)
/// [see]		RoundedRectSliderTrackShape
///
/// The [Home] class represents the main screen of the Flutter application.
/// It is a [StatefulWidget] and contains methods for navigating to different
/// routes and launching URLs.

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

/// The [ _HomeState] class represents the state of the [Home] widget.
class _HomeState extends State<Home> {
  /// Navigates to the 'HTR' (Handwriting Text Recognition) screen.
  navigateToHTR(context) =>
      Navigator.of(context).pushNamed(RouteProvider.htrHome);

  /// Navigates to the 'OCR' (Optical Character Recognition) screen.
  navigateToOCR(context) =>
      Navigator.of(context).pushNamed(RouteProvider.ocrHome);

  /// Defines the URL for the ICFoSS (International Centre for Free and Open Source Software) website.
  final Uri _icfossURL = Uri.parse('https://icfoss.in');

  /// Defines the URL for the ICFoSS GitLab repository.
  final Uri _gitlabURL = Uri.parse('https://gitlab.com/icfoss');

  /// Defines the URL for the ICFoSS LinkedIn page.
  final Uri _linkedInURL =
      Uri.parse('https://www.linkedin.com/company/icfoss-in/');

  /// Defines the URL for the ICFoSS YouTube channel.
  final Uri _youtubeURL =
      Uri.parse('https://www.youtube.com/channel/UCskKbOu_s_VxcK7QOfbvb4w');
  final Uri _androidAppURL = Uri.parse(
      'https://play.google.com/store/apps/details?id=org.icfoss.dhriti&pcampaignid=web_share');

  /// Launches a URL in the device's default web browser.
  ///
  /// Throws an exception if the URL cannot be launched.
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $_icfossURL');
    }
  }

  /// Defines the URL for downloading the APK file of the application.
  String apkFilePath =
      "https://hub.icfoss.org/s/CMATSFwAZwsW4fx/download/app-release.apk";

  /// Defines the URL for downloading the DEB file of the application.
  String debFilePath =
      "https://hub.icfoss.org/s/9cQAYzrASznP4t3/download/htr_2.0.0-3_amd64.deb";

  /// Initiates the download of the APK file.
  /// This method creates an anchor element, sets its attributes, triggers a
  /// click event to download the file, and removes the anchor element after
  /// the download is complete.
  downloadAPK() {
    final anchor = html.AnchorElement()
      ..href = apkFilePath
      ..style.display = 'none'
      ..download = 'malayalam-ocr.apk';
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(apkFilePath);
  }

  /// Initiates the download of the DEB file.
  /// This method creates an anchor element, sets its attributes, triggers a
  /// click event to download the file, and removes the anchor element after
  /// the download is complete.
  downloadDEB() {
    final anchor = html.AnchorElement()
      ..href = debFilePath
      ..style.display = 'none'
      ..download = 'malayalam-ocr.deb';
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(debFilePath);
  }

  /// Represents the result of file picking operation.
  FilePickerResult? result;

  /// Represents the OCR (Optical Character Recognition) upload model.
  UploadOCRModel? ocr;

  /// Represents the HTR (Handwriting Text Recognition) upload model.
  UploadHTRModel? htr;

  /// Indicates whether a file upload is in progress.
  bool isUploading = false;

  /// Indicates whether the automatic mode is enabled for the upload.
  bool isAuto = true;

  /// Quill text editing controller for handling rich text content.
  final fq.QuillController _quillController = fq.QuillController.basic();

  /// Allows the user to choose a file for upload.
  /// This method uses the FilePicker plugin to prompt the user to select a file
  /// with specific allowed extensions and updates the UI accordingly.
  Future<void> chooseFile(setState) async {
    result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'jpeg', 'png']);
    setState(() {});
  }

  /// Uploads the selected file to the appropriate service.
  /// Depending on whether it's an OCR or HTR upload, this method handles the
  /// file upload, updates the UI state, and navigates to the relevant screen.
  Future<void> uploadFile() async {
    if (result != null) {
      Navigator.of(context).pop();
      setState(() {
        isUploading = true;
      });

      Uint8List? fileBytes = result!.files.first.bytes;
      String fileName = result!.files.first.name;
      if (fileBytes != null) {
        if (isHTR) {
          // Upload as HTR and navigate to the segmentation screen.
          // Handle UI updates.
          htr = await uploadHTRWeb(fileBytes, fileName);
          setState(() {});
          setState(() {
            isUploading = false;
            htr!.segment = isAuto ? 'auto' : 'manual';
            Navigator.of(context)
                .pushNamed(RouteProvider.segment, arguments: htr);
          });
        } else {
          // Upload as OCR and navigate to the OCR result screen.
          // Handle UI updates.
          ocr = await uploadOCRWeb(fileBytes, fileName);
          setState(() {});
          setState(() {
            isUploading = false;
            _quillController.clear();
            _quillController.document
                .insert(0, ocr != null ? ocr!.predictedText : '');
            result = null;
            OCRResultModel ocrResult =
                OCRResultModel(ocr: ocr, quillController: _quillController);
            Navigator.of(context)
                .pushNamed(RouteProvider.ocrresult, arguments: ocrResult);
          });
        } // isUploading = false;
      }
    }
  }

  /// Indicates whether the selected upload type is HTR (Handwriting Text Recognition).
  bool isHTR = false;

  /// Displays a download dialog for selecting the target platform.
  /// This method allows the user to choose the target platform (Android or Linux)
  /// for downloading files and handles UI updates accordingly.

  downloadDialog({required double width, bool isDownload = true}) {
    bool linuxSelected = false;

    /// Displays a dialog with dynamic content based on the [isDownload] flag.
    ///
    /// This function shows a dialog with platform-specific download options or
    /// allows the user to select a document type for OCR processing, depending
    /// on the value of [isDownload].
    /// - When [isDownload] is true, it displays Android and Linux download options.
    /// - When [isDownload] is false, it offers choices between printed and handwritten
    ///   document types for OCR processing.
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setState) => Dialog(
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: SizedBox(
                      width: isDownload
                          ? MediaQuery.of(context).size.width * 0.6
                          : MediaQuery.of(context).size.width * 0.5,
                      child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(48.0),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: width > 480
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      isDownload
                                          ? AppLocalizations.of(context)!
                                              .platform_heading
                                          : AppLocalizations.of(context)!
                                              .document_upload_heading,
                                      style: width > 480 ? fB32SB : fB20SB,
                                      textAlign: width > 480
                                          ? TextAlign.start
                                          : TextAlign.center),
                                  h12,
                                  Text(
                                      isDownload
                                          ? AppLocalizations.of(context)!
                                              .platform_subheading
                                          : '${AppLocalizations.of(context)!.document_upload_subheading} ${isHTR ? AppLocalizations.of(context)!.handwritten_segment_type_subheading : ""}',
                                      style: width > 480 ? fTG20N : fTG16N,
                                      textAlign: width > 480
                                          ? TextAlign.start
                                          : TextAlign.center),
                                  h48,
                                  isDownload
                                      ? width > 480
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                  // Android download button
                                                  PlatformItemButton(
                                                      onTap: () => _launchUrl(
                                                          _androidAppURL),
                                                      icon:
                                                          Ionicons.logo_android,
                                                      borderColor: kBlackColor,
                                                      style: fB16M,
                                                      title: AppLocalizations
                                                              .of(context)!
                                                          .platform_item_android),
                                                  // Linux download button
                                                  PlatformItemButton(
                                                      onTap: () => setState(() {
                                                            downloadDEB();

                                                            linuxSelected =
                                                                true;
                                                          }),
                                                      icon: Ionicons.logo_tux,
                                                      borderColor: kBlackColor,
                                                      style: fB16M,
                                                      title: AppLocalizations
                                                              .of(context)!
                                                          .platform_item_linux),
                                                  // Additional platform buttons for wider screens
                                                  if (width > 1200) ...[
                                                    PlatformItemButton(
                                                        icon: Ionicons
                                                            .phone_portrait_outline,
                                                        iconColor:
                                                            kTextGreyColor,
                                                        title: AppLocalizations
                                                                .of(context)!
                                                            .platform_item_ios),
                                                    PlatformItemButton(
                                                        icon: Ionicons
                                                            .logo_windows,
                                                        iconColor:
                                                            kTextGreyColor,
                                                        title: AppLocalizations
                                                                .of(context)!
                                                            .platform_item_windows),
                                                    PlatformItemButton(
                                                        icon:
                                                            Ionicons.logo_apple,
                                                        iconColor:
                                                            kTextGreyColor,
                                                        title: AppLocalizations
                                                                .of(context)!
                                                            .platform_item_macos)
                                                  ]
                                                ])
                                          : Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // Android download button
                                                PlatformItemButton(
                                                    onTap: () => _launchUrl(
                                                        _androidAppURL),
                                                    icon: Ionicons.logo_android,
                                                    borderColor: kBlackColor,
                                                    style: fB16M,
                                                    title: 'Android'),
                                                h16,
                                                // Linux download button
                                                PlatformItemButton(
                                                    onTap: () => setState(() {
                                                          downloadDEB();

                                                          linuxSelected = true;
                                                        }),
                                                    icon: Ionicons.logo_tux,
                                                    borderColor: kBlackColor,
                                                    style: fB16M,
                                                    title: 'Linux')
                                              ],
                                            )
                                      : result == null
                                          ? width >= 1680
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    // Printed document selection
                                                    InkWell(
                                                        onTap: () {
                                                          isHTR = false;
                                                          setState(() {});
                                                          chooseFile(setState);
                                                        },
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                                Radius.circular(
                                                                    32)),
                                                        child: FeatureMenuItem(
                                                            containerColor:
                                                                Colors
                                                                    .transparent,
                                                            border: Border.all(
                                                                color: kTextGreyColor
                                                                    .withOpacity(
                                                                        0.4)),
                                                            icon: Icons
                                                                .description_outlined,
                                                            iconColor:
                                                                kBlueColor,
                                                            iconBackgroundColor:
                                                                kBlueColor.withOpacity(
                                                                    0.1),
                                                            title: AppLocalizations.of(context)!
                                                                .feature_menu_printed,
                                                            description:
                                                                AppLocalizations.of(context)!
                                                                    .feature_menu_printed_description)),
                                                    // Handwritten document selection (Beta)
                                                    Stack(
                                                      children: [
                                                        Positioned(
                                                            top: 0,
                                                            right: 0,
                                                            child: Container(
                                                                padding: pA8,
                                                                decoration: const BoxDecoration(
                                                                    color:
                                                                        kPrimaryColor,
                                                                    borderRadius: BorderRadius.only(
                                                                        topRight:
                                                                            Radius.circular(
                                                                                32),
                                                                        bottomLeft:
                                                                            Radius.circular(
                                                                                16))),
                                                                child: Text(
                                                                    'Beta',
                                                                    style:
                                                                        fW16N))),
                                                        InkWell(
                                                            onTap: () {
                                                              isHTR = true;
                                                              setState(() {});
                                                              chooseFile(
                                                                  setState);
                                                            },
                                                            borderRadius:
                                                                const BorderRadius.all(
                                                                    Radius.circular(
                                                                        32)),
                                                            child: FeatureMenuItem(
                                                                containerColor:
                                                                    Colors
                                                                        .transparent,
                                                                border: Border.all(
                                                                    color: kTextGreyColor.withOpacity(
                                                                        0.4)),
                                                                icon: Icons
                                                                    .document_scanner_outlined,
                                                                iconColor:
                                                                    kPrimaryColor,
                                                                iconBackgroundColor:
                                                                    kPrimaryColor
                                                                        .withOpacity(
                                                                            0.1),
                                                                title: AppLocalizations.of(context)!
                                                                    .feature_menu_handwritten,
                                                                description:
                                                                    AppLocalizations.of(context)!
                                                                        .feature_menu_handwritten_description)),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      // Printed document selection
                                                      InkWell(
                                                          onTap: () {
                                                            isHTR = false;
                                                            setState(() {});
                                                            chooseFile(
                                                                setState);
                                                          },
                                                          borderRadius:
                                                              const BorderRadius.all(
                                                                  Radius.circular(
                                                                      32)),
                                                          child: FeatureMenuItem(
                                                              containerColor:
                                                                  Colors
                                                                      .transparent,
                                                              border: Border.all(
                                                                  color: kTextGreyColor
                                                                      .withOpacity(
                                                                          0.4)),
                                                              icon: Icons
                                                                  .description_outlined,
                                                              iconColor:
                                                                  kBlueColor,
                                                              iconBackgroundColor:
                                                                  kBlueColor.withOpacity(
                                                                      0.1),
                                                              title: AppLocalizations.of(context)!
                                                                  .feature_menu_printed,
                                                              description:
                                                                  AppLocalizations.of(context)!
                                                                      .feature_menu_printed_description)),
                                                      h16,
                                                      // Handwritten document selection (Beta)
                                                      Stack(
                                                        children: [
                                                          Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child: Container(
                                                                  padding: pA8,
                                                                  decoration: const BoxDecoration(
                                                                      color:
                                                                          kPrimaryColor,
                                                                      borderRadius: BorderRadius.only(
                                                                          topRight: Radius.circular(
                                                                              32),
                                                                          bottomLeft: Radius.circular(
                                                                              16))),
                                                                  child: Text(
                                                                      'Beta',
                                                                      style:
                                                                          fW16N))),

                                                          /// Defines an InkWell widget for handling user taps to select Handwritten Text Recognition (HTR) mode.
                                                          /// This InkWell widget is used to activate the HTR mode when tapped. It sets the [isHTR] flag to true,
                                                          /// triggers a UI update using [setState], and invokes the [chooseFile] function to allow the user
                                                          /// to choose a file for processing. The widget also contains a FeatureMenuItem that displays an icon,
                                                          /// title, and description relevant to the handwritten document selection option.
                                                          InkWell(
                                                              onTap: () {
                                                                // Set the isHTR flag to true, enabling Handwritten Text Recognition (HTR) mode.
                                                                isHTR = true;
                                                                setState(
                                                                    () {}); // Trigger a UI update.
                                                                chooseFile(
                                                                    setState); // Prompt the user to select a file for processing.
                                                              },

                                                              /// Specifies the visual attributes of a container and its child FeatureMenuItem.
                                                              /// This code block configures the appearance of a container with rounded corners, which contains
                                                              /// a FeatureMenuItem. The container has a circular [borderRadius], a transparent background color,
                                                              /// and a border with a color that has slight opacity. Inside the container, a FeatureMenuItem displays
                                                              /// an icon, title, and description related to the handwritten document selection option.
                                                              borderRadius:
                                                                  const BorderRadius.all(
                                                                      // Defines rounded corners for the container.
                                                                      Radius.circular(
                                                                          32)),
                                                              child:
                                                                  FeatureMenuItem(
                                                                      containerColor:
                                                                          Colors
                                                                              .transparent, // Sets the container's background color to transparent.
                                                                      border: Border.all(
                                                                          color: kTextGreyColor.withOpacity(
                                                                              0.4)), // Defines a border with slight opacity.
                                                                      icon: Icons
                                                                          .document_scanner_outlined, // Specifies the icon for the FeatureMenuItem.
                                                                      iconColor:
                                                                          kPrimaryColor, // Sets the color of the icon.
                                                                      iconBackgroundColor: kPrimaryColor.withOpacity(
                                                                          // Defines the icon's background color with slight opacity.
                                                                          0.1),
                                                                      title: AppLocalizations.of(
                                                                              context)!
                                                                          .feature_menu_handwritten, // Sets the title text.
                                                                      description:
                                                                          AppLocalizations.of(context)!
                                                                              .feature_menu_handwritten_description)), // Sets the description text.
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )

                                          /// Configures the layout for larger screen widths (greater than or equal to 1680 pixels).
                                          /// When the screen width is 1680 pixels or more, this code block specifies the layout for a Row
                                          /// containing two components: a container and a button. The container displays information about
                                          /// the selected file, including its name and size, while the button allows the user to proceed with
                                          /// file processing. The container has rounded corners, a light background color, and a border with
                                          /// slight opacity. Inside the container, details about the selected file are presented in a
                                          /// structured manner, including the file name and size. Additional options are displayed depending
                                          /// on whether Handwritten Text Recognition (HTR) mode is active.
                                          : width >= 1680
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7),
                                                        width:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.35,
                                                        decoration:
                                                            BoxDecoration(
                                                                color:
                                                                    kWhiteColor, // Background color of the container.
                                                                border: Border.all(
                                                                    color: kTextGreyColor
                                                                        .withOpacity(
                                                                            // Border color with slight opacity.
                                                                            0.2)),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            12))),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(children: [
                                                              w16,
                                                              const Icon(
                                                                  Ionicons
                                                                      .document_outline,
                                                                  size:
                                                                      32), // Size of the document icon.
                                                              w16,
                                                              Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.16,
                                                                      child: Text(
                                                                          result!
                                                                              .files
                                                                              .first
                                                                              .name, // Displayed file name.
                                                                          style:
                                                                              fB16M), // Text style for the file name.
                                                                    ),
                                                                    Text(
                                                                        '${(result!.files.first.size / 1024000).toStringAsFixed(2)} MB', // Displayed file size in megabytes
                                                                        style:
                                                                            fTG16N) // Text style for the file size.
                                                                  ])
                                                            ]),
                                                            Row(
                                                              children: [
                                                                if (isHTR) ...[
                                                                  const Text(
                                                                      'as'), // Displayed when in HTR mode.
                                                                  w8,

                                                                  /// Creates a DropdownButtonFormField for selecting segmentation type.
                                                                  /// This code block defines a DropdownButtonFormField widget that allows the user to select
                                                                  /// the segmentation type for file processing. The dropdown displays two options: 'Automatic'
                                                                  /// and 'Manual', which correspond to the segmentation modes. It also includes an input decoration
                                                                  /// for styling and uses a callback function to handle the user's selection.
                                                                  SizedBox(
                                                                    width:
                                                                        112, // Sets the width of the dropdown field.
                                                                    child:
                                                                        DropdownButtonFormField(
                                                                      value: AppLocalizations.of(
                                                                              context)!
                                                                          .segmentation_button_auto, // Initial selected value.
                                                                      decoration: InputDecoration(
                                                                          contentPadding: const EdgeInsets.only(left: 12), // Padding for dropdown content.
                                                                          border: OutlineInputBorder(
                                                                              borderSide: BorderSide(color: kTextGreyColor.withOpacity(0.4)), // Border color with slight opacity.
                                                                              borderRadius: const BorderRadius.all(Radius.circular(8)))), // Rounded border corners.
                                                                      items: [
                                                                        AppLocalizations.of(context)!
                                                                            .segmentation_button_auto, // Option: 'Automatic'.
                                                                        AppLocalizations.of(context)!
                                                                            .segmentation_button_manual // Option: 'Manual'.
                                                                      ]
                                                                          .map((e) =>
                                                                              DropdownMenuItem(
                                                                                value: e,
                                                                                child: Text(e), // Displayed text for each option.
                                                                              ))
                                                                          .toList(),
                                                                      onChanged:
                                                                          (e) {
                                                                        // Callback function when a new value is selected.
                                                                        isAuto =
                                                                            e ==
                                                                                AppLocalizations.of(context)!.segmentation_button_auto; // Set the 'isAuto' flag based on the selected value.
                                                                      },
                                                                    ),
                                                                  ),
                                                                  w16,
                                                                ],

                                                                /// This code block creates a row of widgets that includes a close button
                                                                /// (for clearing the current selection) and an upload button. The close
                                                                /// button is an IconButton that triggers a callback to reset certain
                                                                IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        isHTR =
                                                                            false; // Resets the 'isHTR' flag.
                                                                        result =
                                                                            null; // Clears the 'result' variable.
                                                                      });
                                                                    },
                                                                    icon: const Icon(
                                                                        Ionicons
                                                                            .close)), // Close icon for clearing the selection.
                                                              ],
                                                            )
                                                          ],
                                                        )),
                                                    w32, // Horizontal spacing.
                                                    CustomElevatedButton(
                                                        onPressed:
                                                            uploadFile, // Callback function when the upload button is pressed.
                                                        child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(AppLocalizations
                                                                      .of(context)!
                                                                  .elevated_button_ext),
                                                              w12,
                                                              const Icon(Icons
                                                                  .arrow_forward_rounded)
                                                            ])),
                                                  ],
                                                )
                                              // This code defines a Flutter Column widget with a specific layout and styling.
                                              : Column(
                                                  children: [
                                                    // Container widget for displaying content
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7),
                                                        width:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.35,
                                                        decoration:
                                                            BoxDecoration(
                                                                color:
                                                                    kWhiteColor, // Background color of the container
                                                                border: Border.all(
                                                                    color: kTextGreyColor
                                                                        .withOpacity(
                                                                            0.2)), // Border color with opacity
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            12))), // Rounded corners
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween, // Vertical alignment
                                                          children: [
                                                            // Close button row (conditionally displayed based on 'width')
                                                            if (width < 675)
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  // Close button that resets certain states when pressed
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          isHTR =
                                                                              false;
                                                                          result =
                                                                              null;
                                                                        });
                                                                      },
                                                                      icon: const Icon(
                                                                          Ionicons
                                                                              .close)),
                                                                ],
                                                              ),
                                                            h16, // Custom widget (possibly a spacer)
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                // Icon and file name row
                                                                Row(children: [
                                                                  // Custom horizontal spacing based on 'width'
                                                                  width > 400
                                                                      ? w16
                                                                      : w4,
                                                                  // Document icon with size based on 'width'
                                                                  Icon(
                                                                      Ionicons
                                                                          .document_outline,
                                                                      size: width >
                                                                              400
                                                                          ? 32
                                                                          : 24),
                                                                  width > 400
                                                                      ? w16
                                                                      : w4,
                                                                  // Column for displaying file name and size
                                                                  Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        // File name with a specified width and style
                                                                        SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.16,
                                                                          child: Text(
                                                                              result!.files.first.name,
                                                                              style: fB16M),
                                                                        ), // File size displayed in MB with a specified width and style
                                                                        SizedBox(
                                                                            width: MediaQuery.of(context).size.width *
                                                                                0.16,
                                                                            child:
                                                                                Text('${(result!.files.first.size / 1024000).toStringAsFixed(2)} MB', style: fTG16N))
                                                                      ])
                                                                ]),
                                                                // Conditional rendering based on screen width ('width')
                                                                if (width >=
                                                                    675)
                                                                  // Render an IconButton with a close icon when the width is greater than or equal to 675
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        // Trigger a state change when the IconButton is pressed
                                                                        setState(
                                                                            () {
                                                                          isHTR =
                                                                              false; // Update 'isHTR' state to false
                                                                          result =
                                                                              null; // Set 'result' to null
                                                                        });
                                                                      },
                                                                      icon: const Icon(
                                                                          Ionicons
                                                                              .close)), // Display a close icon
                                                              ],
                                                            ),
                                                            h8, // Custom widget (possibly a spacer) with a specified height
                                                            // Conditional rendering based on screen width and 'isHTR' state
                                                            width > 675
                                                                ? Row(
                                                                    children: [
                                                                      // Conditional rendering using the spread operator (...)
                                                                      if (isHTR) ...[
                                                                        w16, // Custom horizontal spacing
                                                                        const Text(
                                                                            'Segment as'), // Display a text label
                                                                        w8, // Custom horizontal spacing
                                                                        // Dropdown button for segment selection with a specified width
                                                                        SizedBox(
                                                                          width:
                                                                              112,
                                                                          child:
                                                                              DropdownButtonFormField(
                                                                            value:
                                                                                'Automatic', // Default dropdown value
                                                                            decoration:
                                                                                InputDecoration(contentPadding: const EdgeInsets.only(left: 12), border: OutlineInputBorder(borderSide: BorderSide(color: kTextGreyColor.withOpacity(0.4)), borderRadius: const BorderRadius.all(Radius.circular(8)))),
                                                                            items: [
                                                                              'Automatic',
                                                                              'Manual'
                                                                            ]
                                                                                .map((e) => DropdownMenuItem(
                                                                                      value: e,
                                                                                      child: Text(e),
                                                                                    ))
                                                                                .toList(),
                                                                            onChanged:
                                                                                (e) {
                                                                              // Update 'isAuto' based on dropdown selection
                                                                              isAuto = e == 'Automatic';
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ],
                                                                  )
                                                                : isHTR
                                                                    ? Column(
                                                                        children: [
                                                                          const Text(
                                                                              'Segment as'), // Display a text label
                                                                          w8, // Custom horizontal spacing
                                                                          // Dropdown button for segment selection with a specified width
                                                                          SizedBox(
                                                                            width:
                                                                                112,
                                                                            child:
                                                                                DropdownButtonFormField(
                                                                              value: 'Automatic', // Default dropdown value
                                                                              decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 12), border: OutlineInputBorder(borderSide: BorderSide(color: kTextGreyColor.withOpacity(0.4)), borderRadius: const BorderRadius.all(Radius.circular(8)))),
                                                                              items: [
                                                                                'Automatic',
                                                                                'Manual'
                                                                              ]
                                                                                  .map((e) => DropdownMenuItem(
                                                                                        value: e,
                                                                                        child: Text(e),
                                                                                      ))
                                                                                  .toList(),
                                                                              onChanged: (e) {
                                                                                // Update 'isAuto' based on dropdown selection
                                                                                isAuto = e == 'Automatic';
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : const SizedBox() // An empty SizedBox when 'isHTR' is false
                                                          ],
                                                        )),
                                                    // Additional UI components
                                                    h16, // Custom widget (possibly a spacer) with a specified height
                                                    CustomElevatedButton(
                                                        onPressed:
                                                            uploadFile, // Specify the button's onPressed callback
                                                        child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(AppLocalizations
                                                                      .of(context)!
                                                                  .elevated_button_ext), // Display a localized button label
                                                              w12,
                                                              const Icon(Icons
                                                                  .arrow_forward_rounded) // Display an arrow icon
                                                            ])),
                                                  ],
                                                ),
                                  // Custom spacer with a height of 64 units
                                  h64,
                                  // Conditional rendering based on 'androidSelected'
                                  // if (androidSelected)
                                  // // Display a Column widget with left-aligned content
                                  //   Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     children: [
                                  //       const Divider(), // Horizontal line divider
                                  //       h16, // Custom spacer with a height of 16 units
                                  //       Text(AppLocalizations.of(context)!.android_install,
                                  //           style: fB20N), // Apply a bold 20-point font style
                                  //       h16, // Custom spacer with a height of 16 units
                                  //       Text(
                                  //           AppLocalizations.of(context)!.android_install_1,
                                  //           style: fTG20N), // Apply a normal-weight 20-point font style
                                  //       h4,
                                  //       Text(
                                  //           AppLocalizations.of(context)!.android_install_2,
                                  //           style: fTG20N),
                                  //       h4,
                                  //       Text(
                                  //           AppLocalizations.of(context)!.android_install_3,
                                  //           style: fTG20N),
                                  //       h4,
                                  //       Text(
                                  //           AppLocalizations.of(context)!.android_install_4,
                                  //           style: fTG20N),
                                  //       h4,
                                  //       Text(
                                  //           AppLocalizations.of(context)!.android_install_5,
                                  //           style: fTG20N),
                                  //       h4,
                                  //       Text(
                                  //           AppLocalizations.of(context)!.android_install_6,
                                  //           style: fTG20N),
                                  //     ],
                                  //   ),
                                  // Conditional rendering based on 'linuxSelected'
                                  if (linuxSelected)
                                    // Display a Column widget with left-aligned content
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Divider(), // Horizontal line divider
                                        h16, // Custom spacer with a height of 16 units
                                        Text(
                                            AppLocalizations.of(context)!
                                                .linux_install,
                                            style:
                                                fB20N), // Apply a bold 20-point font style
                                        h16,
                                        Text(
                                            AppLocalizations.of(context)!
                                                .linux_install_1,
                                            style: fTG20N),
                                        h4,
                                        Text(
                                            AppLocalizations.of(context)!
                                                .linux_install_2,
                                            style: fTG20N),
                                        h4,
                                        Text(
                                            AppLocalizations.of(context)!
                                                .linux_install_3,
                                            style: fTG20N),
                                      ],
                                    ),
                                ])),
                      ))));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // App bar with title and language switcher button
            title: Padding(
                padding: const EdgeInsets.only(left: 48.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      // Title text "ധൃതി" with font size based on screen width
                      Text('ധൃതി',
                          style: MediaQuery.of(context).size.width > 400
                              ? fMTG32SB
                              : fMP24SB),
                      w4,
                      // Subtitle text "OCR" with font size based on screen width
                      Text('OCR',
                          style: MediaQuery.of(context).size.width > 400
                              ? fTG30SB
                              : fTG24SB)
                    ])),
            // Language switcher button and additional spacing
            actions: [
              CustomWhiteElevatedButton(
                  onPressed: () {
                    // Change app locale and trigger a rebuild
                    Provider.of<LocaleProvider>(context, listen: false)
                        .changeLocale();
                    setState(() {});
                  },
                  child: Row(children: [
                    // Display "English" or "മലയാളം" based on the selected locale
                    Provider.of<LocaleProvider>(context, listen: false)
                                .locale ==
                            AppLocalizations.supportedLocales[0]
                        ? Text('മലയാളം', style: fMP16N)
                        : const Text('English'),
                    w8,
                    const Icon(Icons.translate_rounded, color: kPrimaryColor)
                  ])),
              w48
            ]),
        body: isUploading
            ? const UploadingIndicator() // Display uploading indicator if isUploading is true
            : LayoutBuilder(builder: (context, contraint) {
                // Content displayed when not uploading
                return SingleChildScrollView(
                    child: Column(children: [
                  Center(
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height - 100,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Main title with font size based on screen width
                                Text(
                                    AppLocalizations.of(context)!
                                        .home_main_title1,
                                    style: contraint.maxWidth > 1000
                                        ? fB72B
                                        : fB32SB,
                                    textAlign: TextAlign.center),
                                Text(
                                    AppLocalizations.of(context)!
                                        .home_main_title2,
                                    style: contraint.maxWidth > 1000
                                        ? fB72B
                                        : fB32SB,
                                    textAlign: TextAlign.center),
                                h18,
                                SizedBox(
                                    width: contraint.maxWidth > 1000
                                        ? MediaQuery.of(context).size.width *
                                            0.4
                                        : MediaQuery.of(context).size.width *
                                            0.8,
                                    // Subtitle text with font style
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .home_sub_title,
                                        style: fTG20N,
                                        textAlign: TextAlign.center)),
                                h32,
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Button for downloading with custom label
                                      CustomWhiteElevatedButton(
                                          onPressed: () => downloadDialog(
                                              width: contraint.maxWidth),
                                          child: Row(
                                            children: [
                                              Text(AppLocalizations.of(context)!
                                                  .home_button_1),
                                              w8,
                                              const Icon(
                                                  Icons.file_download_outlined),
                                            ],
                                          )),
                                      w12,
                                      // Button for another action with custom label
                                      CustomElevatedButton(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .home_button_2),
                                          onPressed: () => downloadDialog(
                                              width: contraint.maxWidth,
                                              isDownload: false))
                                    ])
                              ]))),
                  // A SizedBox widget with a specified width and a Column as its child
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(children: [
                        // Text widget displaying a localized subheading with varying font size based on screen width.
                        Text(AppLocalizations.of(context)!.home_sub_heading,
                            style: contraint.maxWidth > 1000 ? fB64SB : fB32SB,
                            textAlign: TextAlign.center),
                        h8,
                        SizedBox(
                            width: contraint.maxWidth > 1000
                                ? MediaQuery.of(context).size.width * 0.4
                                : MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                                // Text widget displaying a localized sub-description with a specified font style and centered alignment.
                                AppLocalizations.of(context)!
                                    .home_sub_description,
                                style: fTG20N,
                                textAlign: TextAlign.center)),
                        h64,
                        if (contraint.maxWidth > 1000)
                          // Conditional rendering of Row and Column based on screen width.
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(children: [
                                  // FeatureMenuItem widget with custom title, description, and icon.
                                  FeatureMenuItem(
                                      title: AppLocalizations.of(context)!
                                          .feature_title_1,
                                      description: AppLocalizations.of(context)!
                                          .feature_title_desc_1,
                                      icon: Icons.lock_open_rounded,
                                      iconColor: kGreenColor,
                                      iconBackgroundColor:
                                          kGreenColor.withOpacity(0.1)),
                                  h48, //Custom vertical spacing.
                                  FeatureMenuItem(
                                      // FeatureMenuItem widget with custom title, description, and icon.
                                      title: AppLocalizations.of(context)!
                                          .feature_title_2,
                                      description: AppLocalizations.of(context)!
                                          .feature_title_desc_2,
                                      icon: Icons.text_fields_rounded,
                                      iconColor: kPinkColor,
                                      iconBackgroundColor:
                                          kPinkColor.withOpacity(0.1))
                                ]),
                                w48, //Custom vertical spacing.
                                Column(children: [
                                  FeatureMenuItem(
                                      // FeatureMenuItem widget with custom title, description, and icon.
                                      title: AppLocalizations.of(context)!
                                          .feature_title_3,
                                      description: AppLocalizations.of(context)!
                                          .feature_title_desc_3,
                                      icon: Icons.edit_document,
                                      iconColor: kBlueColor,
                                      iconBackgroundColor:
                                          kBlueColor.withOpacity(0.1)),
                                  h48, //Custom vertical spacing.
                                  FeatureMenuItem(
                                      // FeatureMenuItem widget with custom title, description, and icon.
                                      title: AppLocalizations.of(context)!
                                          .feature_title_4,
                                      description: AppLocalizations.of(context)!
                                          .feature_title_desc_4,
                                      icon: Icons.sim_card_download_outlined,
                                      iconColor: kPrimaryColor,
                                      iconBackgroundColor:
                                          kPrimaryColor.withOpacity(0.1))
                                ])
                              ]),
                        if (contraint.maxWidth <= 1000)
                          Column(children: [
                            FeatureMenuItem(
                                // FeatureMenuItem widget with custom title, description, and icon.
                                title: AppLocalizations.of(context)!
                                    .feature_title_1,
                                description: AppLocalizations.of(context)!
                                    .feature_title_desc_1,
                                icon: Icons.lock_open_rounded,
                                iconColor: kGreenColor,
                                iconBackgroundColor:
                                    kGreenColor.withOpacity(0.1)),
                            h48, //Custom vertical spacing.
                            FeatureMenuItem(
                                // FeatureMenuItem widget with custom title, description, and icon.
                                title: AppLocalizations.of(context)!
                                    .feature_title_2,
                                description: AppLocalizations.of(context)!
                                    .feature_title_desc_2,
                                icon: Icons.text_fields_rounded,
                                iconColor: kPinkColor,
                                iconBackgroundColor:
                                    kPinkColor.withOpacity(0.1)),
                            h48, //Custom vertical spacing.
                            FeatureMenuItem(
                                // FeatureMenuItem widget with custom title, description, and icon.
                                title: AppLocalizations.of(context)!
                                    .feature_title_3,
                                description: AppLocalizations.of(context)!
                                    .feature_title_desc_3,
                                icon: Icons.edit_document,
                                iconColor: kBlueColor,
                                iconBackgroundColor:
                                    kBlueColor.withOpacity(0.1)),
                            h48, //Custom vertical spacing.
                            FeatureMenuItem(
                                // FeatureMenuItem widget with custom title, description, and icon.
                                title: AppLocalizations.of(context)!
                                    .feature_title_4,
                                description: AppLocalizations.of(context)!
                                    .feature_title_desc_4,
                                icon: Icons.sim_card_download_outlined,
                                iconColor: kPrimaryColor,
                                iconBackgroundColor:
                                    kPrimaryColor.withOpacity(0.1))
                          ]),
                        h256, //Custom vertical spacing.
                        SizedBox(
                            child: Column(children: [
                          // Text widget displaying a localized text with varying font size based on screen width.
                          Text(AppLocalizations.of(context)!.home_head_below_1,
                              style:
                                  contraint.maxWidth > 1000 ? fTG64SB : fTG32SB,
                              textAlign: TextAlign.center),
                          Text(AppLocalizations.of(context)!.home_head_below_2,
                              style:
                                  contraint.maxWidth > 1000 ? fB64SB : fB32SB,
                              textAlign: TextAlign.center),
                          h24,
                          // A SizedBox widget with a specified width and a Text widget displaying a localized description from AppLocalizations.
                          SizedBox(
                              width: contraint.maxWidth > 1000
                                  ? MediaQuery.of(context).size.width * 0.6
                                  : MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                  AppLocalizations.of(context)!
                                      .home_below_description,
                                  style: fB20N,
                                  textAlign: TextAlign.center)),
                          h32,
                          // CustomElevatedButton widget with onPressed action to launch a URL and a Text widget displaying a localized button label.
                          CustomElevatedButton(
                              onPressed: () => _launchUrl(_icfossURL),
                              child: Text(AppLocalizations.of(context)!
                                  .home_below_button))
                        ])),
                        // Fixed vertical spacing.
                        const SizedBox(height: 100),
                        // A horizontal divider.
                        const Divider(),
                        h32,
                        // Row widget with mainAxisAlignment between its children and two Column widgets.
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Column widget displaying "Powered By" and "ICFOSS" text with specified font styles.
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Powered By', style: fTG20N),
                                    Text('ICFOSS', style: fB32SB)
                                  ]),
                              contraint.maxWidth > 480
                                  ? Row(children: [
                                      Tooltip(
                                          // Tooltip widget with an IconButton to launch Gitlab URL.
                                          message: 'Gitlab',
                                          child: IconButton(
                                              onPressed: () =>
                                                  _launchUrl(_gitlabURL),
                                              icon: const Icon(
                                                  Ionicons.logo_gitlab))),
                                      w8,
                                      Tooltip(
                                          // Tooltip widget with an IconButton to launch LinkedIn URL.
                                          message: 'LinkedIn',
                                          child: IconButton(
                                              onPressed: () =>
                                                  _launchUrl(_linkedInURL),
                                              icon: const Icon(
                                                  Ionicons.logo_linkedin))),
                                      w8,
                                      Tooltip(
                                          // Tooltip widget with an IconButton to launch icfoss.in URL.
                                          message: 'icfoss.in',
                                          child: IconButton(
                                              onPressed: () =>
                                                  _launchUrl(_icfossURL),
                                              icon: const Icon(
                                                  Icons.language_rounded))),
                                      w8,
                                      Tooltip(
                                          // Tooltip widget with an IconButton to launch Youtube URL
                                          message: 'Youtube',
                                          child: IconButton(
                                              onPressed: () =>
                                                  _launchUrl(_youtubeURL),
                                              icon: const Icon(
                                                  Ionicons.logo_youtube)))
                                    ])
                                  : Row(children: [
                                      Column(
                                        children: [
                                          Tooltip(
                                              // Tooltip widget with an IconButton to launch Gitlab URL.
                                              message: 'Gitlab',
                                              child: IconButton(
                                                  onPressed: () =>
                                                      _launchUrl(_gitlabURL),
                                                  icon: const Icon(
                                                      Ionicons.logo_gitlab))),
                                          w8,
                                          Tooltip(
                                              // Tooltip widget with an IconButton to launch LinkedIn URL.
                                              message: 'LinkedIn',
                                              child: IconButton(
                                                  onPressed: () =>
                                                      _launchUrl(_linkedInURL),
                                                  icon: const Icon(
                                                      Ionicons.logo_linkedin))),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Tooltip(
                                              // Tooltip widget with an IconButton to launch icfoss.in URL.
                                              message: 'icfoss.in',
                                              child: IconButton(
                                                  onPressed: () =>
                                                      _launchUrl(_icfossURL),
                                                  icon: const Icon(
                                                      Icons.language_rounded))),
                                          w8,
                                          Tooltip(
                                              // Tooltip widget with an IconButton to launch Youtube URL.
                                              message: 'Youtube',
                                              child: IconButton(
                                                  onPressed: () =>
                                                      _launchUrl(_youtubeURL),
                                                  icon: const Icon(
                                                      Ionicons.logo_youtube)))
                                        ],
                                      ),
                                    ])
                            ]),
                        h32
                      ]))
                ]));
              }));
  }
}

/// A custom button widget for platform-specific actions.
class PlatformItemButton extends StatelessWidget {
  /// A callback function to be executed when the button is tapped.
  final VoidCallback? onTap;

  /// The border color of the button
  final Color? borderColor;

  /// The icon to be displayed on the button.
  final IconData icon;

  /// The color of the icon.
  final Color? iconColor;

  /// The title or label of the button.
  final String title;

  /// The text style applied to the title.
  final TextStyle? style;

  /// Creates a [PlatformItemButton] widget.
  /// [onTap] is an optional callback function that gets triggered when the button is tapped.
  /// [borderColor] specifies the border color of the button. If not provided, it defaults to [kTextGreyColor].
  /// [icon] is the IconData representing the icon displayed on the button.
  /// [iconColor] is the color of the icon. If not provided, it follows the default styling.
  /// [title] is the text or label displayed below the icon.
  /// [style] is an optional text style applied to the title. If not provided, it uses the default [fTG16N] style.
  const PlatformItemButton({
    this.onTap,
    this.borderColor,
    required this.icon,
    this.iconColor,
    required this.title,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
          // InkWell widget for tap handling with a circular border.
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: borderColor ?? kTextGreyColor),
                  borderRadius: const BorderRadius.all(Radius.circular(100))),
              padding: pA32,
              child:
                  Column(children: [Icon(icon, size: 48, color: iconColor)]))),
      h16,
      Text(title, style: style ?? fTG16N)
    ]);
  }
}

/// A custom widget representing a feature menu item with a title, description,
/// and an associated icon.
///
/// This widget is designed to display a feature menu item with customizable
/// properties such as title, description, icon, icon colors, container colors,
/// and borders.
///
/// Parameters:
/// - [title]: The title of the feature menu item.
/// - [description]: The description of the feature menu item.
/// - [icon]: The icon displayed at the center of the menu item.
/// - [iconColor]: The color of the icon.
/// - [iconBackgroundColor]: The background color of the icon container.
/// - [containerColor]: The background color of the menu item container. If not
///   specified, it defaults to the `kContainerBackgroundColor`.
/// - [border]: The border configuration for the menu item container.
///
class FeatureMenuItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color? containerColor;
  final BoxBorder? border;

  /// Constructs a [FeatureMenuItem] widget.
  ///
  /// The [title], [description], [icon], [iconColor], and [iconBackgroundColor]
  /// parameters are required. All other parameters are optional.
  const FeatureMenuItem(
      {super.key,
      required this.title,
      required this.description,
      required this.icon,
      required this.iconColor,
      this.containerColor,
      this.border,
      required this.iconBackgroundColor});

  /// Builds the UI for the [FeatureMenuItem] widget.
  ///
  /// This method constructs the visual representation of the [FeatureMenuItem].
  /// It creates a container with customizable padding, background color, and
  /// border. Inside the container, it displays the icon, title, and description
  /// of the menu item in a structured layout.
  ///
  /// Returns:
  /// - A [Container] widget representing the feature menu item.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: pA32,
      decoration: BoxDecoration(
          color: containerColor ?? kContainerBackgroundColor,
          border: border,
          borderRadius: const BorderRadius.all(Radius.circular(32))),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(100)),
          child: Icon(icon, color: iconColor),
        ),
        h12,
        Text(title, style: fB18SB),
        h8,
        SizedBox(
            width: 300,
            child:
                Text(description, style: fTG16N, textAlign: TextAlign.center))
      ]),
    );
  }
}

/// A custom widget representing the ICFOSS logo.
///
/// This widget displays the ICFOSS logo image along with a "Powered by" text.
class IcfossLogo extends StatelessWidget {
  const IcfossLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Powered by', style: fP16SB),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Image.asset('assets/logo/ICFOSS_Logo.png'))
      ],
    );
  }
}

/// A custom widget representing a large menu item with an icon, title,
/// description, and an associated callback.
///
/// This widget is designed to display a large menu item with customizable
/// properties such as icon, title, description, and an action to be performed
/// when tapped.
///
/// Parameters:
/// - [icon]: The icon to be displayed as part of the menu item.
/// - [title]: The title of the menu item.
/// - [description]: A brief description of the menu item.
/// - [onTap]: The callback function to be executed when the menu item is tapped.
///
class MenuChildLarge extends StatelessWidget {
  final Widget icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  const MenuChildLarge({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: pA8,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  spreadRadius: -1,
                  blurRadius: 2,
                  color: Colors.black.withOpacity(.4))
            ]),
        child: InkWell(
            onTap:
                onTap, // Define the action to be performed when the menu item is tapped.
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 80, child: icon),
                  Text(title, style: fP16SB)
                ])));
  }
}

/// A custom widget representing a menu item with an icon, title, and an
/// associated callback.
///
/// This widget is designed to display a menu item with customizable properties
/// such as icon, title, description, and an action to be performed when tapped.
///
/// Parameters:
/// - [icon]: The icon to be displayed as part of the menu item.
/// - [title]: The title of the menu item.
/// - [description]: A brief description of the menu item.
/// - [onTap]: The callback function to be executed when the menu item is tapped.
///

class MenuChild extends StatelessWidget {
  final Widget icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  const MenuChild(

      /// Constructs a [MenuChild] widget.
      ///
      /// The [icon], [title], [description], and [onTap] parameters are required.
      /// All other parameters are optional.
      {required this.icon,
      required this.title,
      required this.description,
      required this.onTap,
      super.key});

  /// Builds the UI for the [MenuChild] widget.
  ///
  /// This method constructs the visual representation of the [MenuChild]. It
  /// creates a container with customizable padding, background color, and shadow.
  /// Inside the container, it displays the icon and title in a column layout.
  ///
  /// Returns:
  /// - A [Container] widget representing the menu item.
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: pL8T8B4R8,
        padding: pA8,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  spreadRadius: -1,
                  blurRadius: 2,
                  color: Colors.black.withOpacity(.4))
            ]),
        child: InkWell(
          onTap: onTap,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 90, child: icon),
            w8,
            Flexible(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title, style: fP16SB),
                  h4,
                  Text(description, style: fG14N)
                ]))
          ]),
        ));
  }
}
