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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  navigateToHTR(context) =>
      Navigator.of(context).pushNamed(RouteProvider.htrHome);

  navigateToOCR(context) =>
      Navigator.of(context).pushNamed(RouteProvider.ocrHome);

  final Uri _icfossURL = Uri.parse('https://icfoss.in');
  final Uri _gitlabURL = Uri.parse('https://gitlab.com/icfoss');
  final Uri _linkedInURL =
      Uri.parse('https://www.linkedin.com/company/icfoss-in/');
  final Uri _youtubeURL =
      Uri.parse('https://www.youtube.com/channel/UCskKbOu_s_VxcK7QOfbvb4w');
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $_icfossURL');
    }
  }

  String apkFilePath =
      "https://hub.icfoss.org/s/CMATSFwAZwsW4fx/download/app-release.apk";
  String debFilePath =
      "https://hub.icfoss.org/s/9cQAYzrASznP4t3/download/htr_2.0.0-3_amd64.deb";
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

  FilePickerResult? result;
  UploadOCRModel? ocr;
  UploadHTRModel? htr;
  bool isUploading = false;
  bool isAuto = true;

  final fq.QuillController _quillController = fq.QuillController.basic();
  Future<void> chooseFile(setState) async {
    result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'jpeg', 'png']);
    setState(() {});
  }

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
          htr = await uploadHTRWeb(fileBytes, fileName);
          setState(() {});
          setState(() {
            isUploading = false;
            htr!.segment = isAuto ? 'auto' : 'manual';
            Navigator.of(context)
                .pushNamed(RouteProvider.segment, arguments: htr);
          });
        } else {
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

  bool isHTR = false;

  downloadDialog({required double width, bool isDownload = true}) {
    bool androidSelected = false;
    bool linuxSelected = false;

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
                                          ? 'Select the platform of your choice'
                                          : 'Select your document type',
                                      style: width > 480 ? fB32SB : fB20SB,
                                      textAlign: width > 480
                                          ? TextAlign.start
                                          : TextAlign.center),
                                  h12,
                                  Text(
                                      isDownload
                                          ? "Choose the device of your preference from the platforms below to ensure that you always have Dhriti OCR at your fingertips."
                                          : 'Choose the desired document type from the options below to extract text using Dhriti OCR. ${isHTR ? "Also specify the segment type as automatic or manual." : ""}',
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
                                                  PlatformItemButton(
                                                      onTap: () => setState(() {
                                                            downloadAPK();
                                                            linuxSelected =
                                                                false;
                                                            androidSelected =
                                                                true;
                                                          }),
                                                      icon: Icons
                                                          .phone_android_rounded,
                                                      borderColor: kBlackColor,
                                                      style: fB16M,
                                                      title: 'Android'),
                                                  PlatformItemButton(
                                                      onTap: () => setState(() {
                                                            downloadDEB();
                                                            androidSelected =
                                                                false;
                                                            linuxSelected =
                                                                true;
                                                          }),
                                                      icon: Ionicons.logo_tux,
                                                      borderColor: kBlackColor,
                                                      style: fB16M,
                                                      title: 'Linux'),
                                                  if (width > 1200) ...[
                                                    const PlatformItemButton(
                                                        icon: Ionicons
                                                            .phone_portrait_outline,
                                                        iconColor:
                                                            kTextGreyColor,
                                                        title: 'iOS'),
                                                    const PlatformItemButton(
                                                        icon: Ionicons
                                                            .logo_windows,
                                                        iconColor:
                                                            kTextGreyColor,
                                                        title: 'Windows'),
                                                    const PlatformItemButton(
                                                        icon:
                                                            Ionicons.logo_apple,
                                                        iconColor:
                                                            kTextGreyColor,
                                                        title: 'MacOS')
                                                  ]
                                                ])
                                          : Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                PlatformItemButton(
                                                    onTap: () => setState(() {
                                                          downloadAPK();
                                                          linuxSelected = false;
                                                          androidSelected =
                                                              true;
                                                        }),
                                                    icon: Icons
                                                        .phone_android_rounded,
                                                    borderColor: kBlackColor,
                                                    style: fB16M,
                                                    title: 'Android'),
                                                h16,
                                                PlatformItemButton(
                                                    onTap: () => setState(() {
                                                          downloadDEB();
                                                          androidSelected =
                                                              false;
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
                                                                kBlueColor
                                                                    .withOpacity(
                                                                        0.1),
                                                            title: 'Printed',
                                                            description:
                                                                'Capture Malayalam and English text from books, articles, and more')),
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
                                                                    color: kTextGreyColor
                                                                        .withOpacity(
                                                                            0.4)),
                                                                icon: Icons
                                                                    .document_scanner_outlined,
                                                                iconColor:
                                                                    kPrimaryColor,
                                                                iconBackgroundColor:
                                                                    kPrimaryColor
                                                                        .withOpacity(
                                                                            0.1),
                                                                title:
                                                                    'Handwritten',
                                                                description:
                                                                    'Transform your Malayalam handwritten notes, letters, and more.')),
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
                                                                  kBlueColor
                                                                      .withOpacity(
                                                                          0.1),
                                                              title: 'Printed',
                                                              description:
                                                                  'Capture Malayalam and English text from books, articles, and more')),
                                                      h16,
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
                                                                      color: kTextGreyColor
                                                                          .withOpacity(
                                                                              0.4)),
                                                                  icon: Icons
                                                                      .document_scanner_outlined,
                                                                  iconColor:
                                                                      kPrimaryColor,
                                                                  iconBackgroundColor:
                                                                      kPrimaryColor.withOpacity(
                                                                          0.1),
                                                                  title:
                                                                      'Handwritten',
                                                                  description:
                                                                      'Transform your Malayalam handwritten notes, letters, and more.')),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
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
                                                            const EdgeInsets.all(
                                                                7),
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.35,
                                                        decoration: BoxDecoration(
                                                            color: kWhiteColor,
                                                            border: Border.all(
                                                                color: kTextGreyColor
                                                                    .withOpacity(
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
                                                                  size: 32),
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
                                                                              .name,
                                                                          style:
                                                                              fB16M),
                                                                    ),
                                                                    Text(
                                                                        '${(result!.files.first.size / 1024000).toStringAsFixed(2)} MB',
                                                                        style:
                                                                            fTG16N)
                                                                  ])
                                                            ]),
                                                            Row(
                                                              children: [
                                                                if (isHTR) ...[
                                                                  const Text(
                                                                      'as'),
                                                                  w8,
                                                                  SizedBox(
                                                                    width: 112,
                                                                    child:
                                                                        DropdownButtonFormField(
                                                                      value:
                                                                          'Automatic',
                                                                      decoration: InputDecoration(
                                                                          contentPadding: const EdgeInsets
                                                                              .only(
                                                                              left:
                                                                                  12),
                                                                          border: OutlineInputBorder(
                                                                              borderSide: BorderSide(color: kTextGreyColor.withOpacity(0.4)),
                                                                              borderRadius: const BorderRadius.all(Radius.circular(8)))),
                                                                      items: [
                                                                        'Automatic',
                                                                        'Manual'
                                                                      ]
                                                                          .map((e) =>
                                                                              DropdownMenuItem(
                                                                                value: e,
                                                                                child: Text(e),
                                                                              ))
                                                                          .toList(),
                                                                      onChanged:
                                                                          (e) {
                                                                        isAuto =
                                                                            e ==
                                                                                'Automatic';
                                                                      },
                                                                    ),
                                                                  ),
                                                                  w16,
                                                                ],
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
                                                            )
                                                          ],
                                                        )),
                                                    w32,
                                                    CustomElevatedButton(
                                                        onPressed: uploadFile,
                                                        child: const Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text('Extract'),
                                                              w12,
                                                              Icon(Icons
                                                                  .arrow_forward_rounded)
                                                            ])),
                                                  ],
                                                )
                                              : Center(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  7),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.35,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  kWhiteColor,
                                                              border: Border.all(
                                                                  color: kTextGreyColor
                                                                      .withOpacity(
                                                                          0.2)),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          12))),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              if (width < 675)
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
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
                                                                            Ionicons.close)),
                                                                  ],
                                                                ),
                                                              h16,
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                      children: [
                                                                        width > 400
                                                                            ? w16
                                                                            : w4,
                                                                        Icon(
                                                                            Ionicons
                                                                                .document_outline,
                                                                            size: width > 400
                                                                                ? 32
                                                                                : 24),
                                                                        width > 400
                                                                            ? w16
                                                                            : w4,
                                                                        Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.16,
                                                                                child: Text(result!.files.first.name, style: fB16M),
                                                                              ),
                                                                              SizedBox(width: MediaQuery.of(context).size.width * 0.16, child: Text('${(result!.files.first.size / 1024000).toStringAsFixed(2)} MB', style: fTG16N))
                                                                            ])
                                                                      ]),
                                                                  if (width >=
                                                                      675)
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
                                                                            Ionicons.close)),
                                                                ],
                                                              ),
                                                              h8,
                                                              width > 675
                                                                  ? Row(
                                                                      children: [
                                                                        if (isHTR) ...[
                                                                          w16,
                                                                          const Text(
                                                                              'Segment as'),
                                                                          w8,
                                                                          SizedBox(
                                                                            width:
                                                                                112,
                                                                            child:
                                                                                DropdownButtonFormField(
                                                                              value: 'Automatic',
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
                                                                            const Text('Segment as'),
                                                                            w8,
                                                                            SizedBox(
                                                                              width: 112,
                                                                              child: DropdownButtonFormField(
                                                                                value: 'Automatic',
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
                                                                                  isAuto = e == 'Automatic';
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : const SizedBox()
                                                            ],
                                                          )),
                                                      h16,
                                                      CustomElevatedButton(
                                                          onPressed: uploadFile,
                                                          child: const Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text('Extract'),
                                                                w12,
                                                                Icon(Icons
                                                                    .arrow_forward_rounded)
                                                              ])),
                                                    ],
                                                  ),
                                                ),
                                  h64,
                                  if (androidSelected)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Divider(),
                                        h16,
                                        Text('Installation Instructions:',
                                            style: fB20N),
                                        h16,
                                        Text(
                                            '1. After downloading, Go to Settings > Security',
                                            style: fTG20N),
                                        h4,
                                        Text(
                                            '2. Enable the Unknown sources option to allow installation from sources other than the Play Store.',
                                            style: fTG20N),
                                        h4,
                                        Text(
                                            '3. Open the file manager and navigate to the downloaded APK file.',
                                            style: fTG20N),
                                        h4,
                                        Text(
                                            '4. Tap on the APK file to begin the installation process.',
                                            style: fTG20N),
                                        h4,
                                        Text(
                                            '5. Follow the on-screen prompts to complete the installation.',
                                            style: fTG20N),
                                        h4,
                                        Text(
                                            '6. Once installed, you can find and use the app from your device\'s app drawer.',
                                            style: fTG20N),
                                      ],
                                    ),
                                  if (linuxSelected)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Divider(),
                                        h16,
                                        Text('Installation Instructions:',
                                            style: fB20N),
                                        h16,
                                        Text(
                                            '1. After downloading, Open terminal.',
                                            style: fTG20N),
                                        h4,
                                        Text(
                                            '2. Navigate to the directory containing the downloaded DEB file.',
                                            style: fTG20N),
                                        h4,
                                        Text(
                                            '3. Run "sudo dpkg -i malayalam_ocr_app.deb".',
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
            title: Padding(
                padding: const EdgeInsets.only(left: 48.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('ധൃതി',
                          style: MediaQuery.of(context).size.width > 1400
                              ? fMTG32SB
                              : fMTG24SB),
                      w4,
                      Text('OCR',
                          style: MediaQuery.of(context).size.width > 1400
                              ? fTG30SB
                              : fTG24SB)
                    ])),
            actions: [
              CustomWhiteElevatedButton(
                  onPressed: () {
                    Provider.of<LocaleProvider>(context, listen: false)
                        .changeLocale();
                    setState(() {});
                  },
                  padding: MediaQuery.of(context).size.width > 1400
                      ? null
                      : const EdgeInsets.only(top: 8, bottom: 8),
                  child: Row(children: [
                    Provider.of<LocaleProvider>(context, listen: false)
                                .locale ==
                            AppLocalizations.supportedLocales[0]
                        ? const Text('English')
                        : Text('മലയാളം', style: fMP16N),
                    w8,
                    const Icon(Icons.translate_rounded, color: kPrimaryColor)
                  ])),
              w48
            ]),
        body: isUploading
            ? const UploadingIndicator()
            : LayoutBuilder(builder: (context, contraint) {
                return SingleChildScrollView(
                    child: Column(children: [
                  Center(
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height - 100,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Empowering Efficient',
                                    style: contraint.maxWidth > 1000
                                        ? contraint.maxWidth > 1400
                                            ? fB72B
                                            : fB56B
                                        : fB32SB,
                                    textAlign: TextAlign.center),
                                Text('Document Digitalisation',
                                    style: contraint.maxWidth > 1000
                                        ? contraint.maxWidth > 1400
                                            ? fB72B
                                            : fB56B
                                        : fB32SB,
                                    textAlign: TextAlign.center),
                                h18,
                                SizedBox(
                                    width: contraint.maxWidth > 1000
                                        ? MediaQuery.of(context).size.width *
                                            0.4
                                        : MediaQuery.of(context).size.width *
                                            0.8,
                                    child: Text(
                                        "An open source solution to effortlessly convert printed and handwritten Malyalam content into editable text, Transform your documents with ease.",
                                        style: contraint.maxWidth > 1400
                                            ? fTG20N
                                            : fTG18N,
                                        textAlign: TextAlign.center)),
                                h32,
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomWhiteElevatedButton(
                                          onPressed: () => downloadDialog(
                                              width: contraint.maxWidth),
                                          child: const Row(
                                            children: [
                                              Text('Download Solution'),
                                              w8,
                                              Icon(
                                                  Icons.file_download_outlined),
                                            ],
                                          )),
                                      w12,
                                      CustomElevatedButton(
                                          child: const Text('Try Now'),
                                          onPressed: () => downloadDialog(
                                              width: contraint.maxWidth,
                                              isDownload: false))
                                    ])
                              ]))),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(children: [
                        Text('What we offer',
                            style: contraint.maxWidth > 1000
                                ? contraint.maxWidth > 1400
                                    ? fB64SB
                                    : fB48SB
                                : fB32SB,
                            textAlign: TextAlign.center),
                        h8,
                        SizedBox(
                            width: contraint.maxWidth > 1000
                                ? MediaQuery.of(context).size.width * 0.4
                                : MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                                'Unlimited access, transparent and open. Dhriti provides a easy text extraction tool exclusively for malayalam',
                                style:
                                    contraint.maxWidth > 1400 ? fTG20N : fTG18N,
                                textAlign: TextAlign.center)),
                        h64,
                        if (contraint.maxWidth > 1000)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(children: [
                                  FeatureMenuItem(
                                      title: 'Open Source',
                                      description:
                                          'The tool free to use and open to contribute.',
                                      icon: Icons.lock_open_rounded,
                                      iconColor: kGreenColor,
                                      iconBackgroundColor:
                                          kGreenColor.withOpacity(0.1)),
                                  h48,
                                  FeatureMenuItem(
                                      title: 'Text Extraction',
                                      description:
                                          'Instantly extract Malayalam text from documents and images.',
                                      icon: Icons.text_fields_rounded,
                                      iconColor: kPinkColor,
                                      iconBackgroundColor:
                                          kPinkColor.withOpacity(0.1))
                                ]),
                                w48,
                                Column(children: [
                                  FeatureMenuItem(
                                      title: 'Editable Output',
                                      description:
                                          'Easily edit the extracted text within the tool\'s interface.',
                                      icon: Icons.edit_document,
                                      iconColor: kBlueColor,
                                      iconBackgroundColor:
                                          kBlueColor.withOpacity(0.1)),
                                  h48,
                                  FeatureMenuItem(
                                      title: 'Export Feature',
                                      description:
                                          'Seamlessly export the extracted and edited Malayalam text.',
                                      icon: Icons.sim_card_download_outlined,
                                      iconColor: kPrimaryColor,
                                      iconBackgroundColor:
                                          kPrimaryColor.withOpacity(0.1))
                                ])
                              ]),
                        if (contraint.maxWidth <= 1000)
                          Column(children: [
                            FeatureMenuItem(
                                title: 'Open Source',
                                description:
                                    'The tool free to use and open to contribute.',
                                icon: Icons.lock_open_rounded,
                                iconColor: kGreenColor,
                                iconBackgroundColor:
                                    kGreenColor.withOpacity(0.1)),
                            h48,
                            FeatureMenuItem(
                                title: 'Text Extraction',
                                description:
                                    'Instantly extract Malayalam text from documents and images.',
                                icon: Icons.text_fields_rounded,
                                iconColor: kPinkColor,
                                iconBackgroundColor:
                                    kPinkColor.withOpacity(0.1)),
                            h48,
                            FeatureMenuItem(
                                title: 'Editable Output',
                                description:
                                    'Easily edit the extracted text within the tool\'s interface.',
                                icon: Icons.edit_document,
                                iconColor: kBlueColor,
                                iconBackgroundColor:
                                    kBlueColor.withOpacity(0.1)),
                            h48,
                            FeatureMenuItem(
                                title: 'Export Feature',
                                description:
                                    'Seamlessly export the extracted and edited Malayalam text.',
                                icon: Icons.sim_card_download_outlined,
                                iconColor: kPrimaryColor,
                                iconBackgroundColor:
                                    kPrimaryColor.withOpacity(0.1))
                          ]),
                        h256,
                        SizedBox(
                            child: Column(children: [
                          Text('We\'re not just shaping software',
                              style: contraint.maxWidth > 1000
                                  ? contraint.maxWidth > 1400
                                      ? fTG64SB
                                      : fTG48SB
                                  : fTG32SB,
                              textAlign: TextAlign.center),
                          Text('We\'re shaping the future.',
                              style: contraint.maxWidth > 1000
                                  ? contraint.maxWidth > 1400
                                      ? fB64SB
                                      : fB48SB
                                  : fB32SB,
                              textAlign: TextAlign.center),
                          h24,
                          SizedBox(
                              width: contraint.maxWidth > 1000
                                  ? MediaQuery.of(context).size.width * 0.6
                                  : MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                  'Dhriti is an open source tool crafted by Language Technology team at ICFOSS (International Centre for Free and Open Source Software), we embody the spirit of open source innovation and collaboration. Established as a pioneering institution, we are fervently dedicated to driving the widespread adoption of open-source technology. Our journey is one of fostering positive change through technology. Rooted in the principles of openness, transparency, and community, ICFOSS is a hub for individuals and organizations passionate about the transformative power of open source.',
                                  style: contraint.maxWidth > 1400
                                      ? fTG20N
                                      : fTG18N,
                                  textAlign: TextAlign.center)),
                          h32,
                          CustomElevatedButton(
                              onPressed: () => _launchUrl(_icfossURL),
                              child: const Text('Learn More'))
                        ])),
                        const SizedBox(height: 100),
                        const Divider(),
                        h32,
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Powered By',
                                        style: contraint.maxWidth > 1400
                                            ? fTG20N
                                            : fTG18N),
                                    Text('ICFOSS',
                                        style: contraint.maxWidth > 1400
                                            ? fB32SB
                                            : fB24SB)
                                  ]),
                              contraint.maxWidth > 480
                                  ? Row(children: [
                                      Tooltip(
                                          message: 'Gitlab',
                                          child: IconButton(
                                              onPressed: () =>
                                                  _launchUrl(_gitlabURL),
                                              icon: const Icon(
                                                  Ionicons.logo_gitlab))),
                                      w8,
                                      Tooltip(
                                          message: 'LinkedIn',
                                          child: IconButton(
                                              onPressed: () =>
                                                  _launchUrl(_linkedInURL),
                                              icon: const Icon(
                                                  Ionicons.logo_linkedin))),
                                      w8,
                                      Tooltip(
                                          message: 'icfoss.in',
                                          child: IconButton(
                                              onPressed: () =>
                                                  _launchUrl(_icfossURL),
                                              icon: const Icon(
                                                  Icons.language_rounded))),
                                      w8,
                                      Tooltip(
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
                                              message: 'Gitlab',
                                              child: IconButton(
                                                  onPressed: () =>
                                                      _launchUrl(_gitlabURL),
                                                  icon: const Icon(
                                                      Ionicons.logo_gitlab))),
                                          w8,
                                          Tooltip(
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
                                              message: 'icfoss.in',
                                              child: IconButton(
                                                  onPressed: () =>
                                                      _launchUrl(_icfossURL),
                                                  icon: const Icon(
                                                      Icons.language_rounded))),
                                          w8,
                                          Tooltip(
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

class PlatformItemButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? borderColor;
  final IconData icon;
  final Color? iconColor;
  final String title;
  final TextStyle? style;
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

class FeatureMenuItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color? containerColor;
  final BoxBorder? border;
  const FeatureMenuItem(
      {super.key,
      required this.title,
      required this.description,
      required this.icon,
      required this.iconColor,
      this.containerColor,
      this.border,
      required this.iconBackgroundColor});

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
            onTap: onTap,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 80, child: icon),
                  Text(title, style: fP16SB)
                ])));
  }
}

class MenuChild extends StatelessWidget {
  final Widget icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  const MenuChild(
      {required this.icon,
      required this.title,
      required this.description,
      required this.onTap,
      super.key});

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