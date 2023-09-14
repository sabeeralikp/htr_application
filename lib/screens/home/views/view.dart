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
              builder: (context, setState) => Expanded(
                  child: Dialog(
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
                                              ? AppLocalizations.of(context).platform_heading
                                              : AppLocalizations.of(context).document_upload_heading,
                                          style: width > 480 ? fB32SB : fB20SB,
                                          textAlign: width > 480
                                              ? TextAlign.start
                                              : TextAlign.center),
                                      h12,
                                      Text(
                                          isDownload
                                              ? AppLocalizations.of(context).platform_subheading
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                      PlatformItemButton(
                                                          onTap: () =>
                                                              setState(() {
                                                                downloadAPK();
                                                                linuxSelected =
                                                                    false;
                                                                androidSelected =
                                                                    true;
                                                              }),
                                                          icon: Icons
                                                              .phone_android_rounded,
                                                          borderColor:
                                                              kBlackColor,
                                                          style: fB16M,
                                                          title: AppLocalizations.of(context).platform_item_android),
                                                      PlatformItemButton(
                                                          onTap: () =>
                                                              setState(() {
                                                                downloadDEB();
                                                                androidSelected =
                                                                    false;
                                                                linuxSelected =
                                                                    true;
                                                              }),
                                                          icon:
                                                              Ionicons.logo_tux,
                                                          borderColor:
                                                              kBlackColor,
                                                          style: fB16M,
                                                          title: AppLocalizations.of(context).platform_item_linux),
                                                      if (width > 1200) ...[
                                                         PlatformItemButton(
                                                            icon: Ionicons
                                                                .phone_portrait_outline,
                                                            iconColor:
                                                                kTextGreyColor,
                                                            title: AppLocalizations.of(context).platform_item_ios),
                                                         PlatformItemButton(
                                                            icon: Ionicons
                                                                .logo_windows,
                                                            iconColor:
                                                                kTextGreyColor,
                                                            title: AppLocalizations.of(context).platform_item_windows),
                                                         PlatformItemButton(
                                                            icon: Ionicons
                                                                .logo_apple,
                                                            iconColor:
                                                                kTextGreyColor,
                                                            title: AppLocalizations.of(context).platform_item_macos)
                                                      ]
                                                    ])
                                              : Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    PlatformItemButton(
                                                        onTap: () =>
                                                            setState(() {
                                                              downloadAPK();
                                                              linuxSelected =
                                                                  false;
                                                              androidSelected =
                                                                  true;
                                                            }),
                                                        icon: Icons
                                                            .phone_android_rounded,
                                                        borderColor:
                                                            kBlackColor,
                                                        style: fB16M,
                                                        title: 'Android'),
                                                    h16,
                                                    PlatformItemButton(
                                                        onTap: () =>
                                                            setState(() {
                                                              downloadDEB();
                                                              androidSelected =
                                                                  false;
                                                              linuxSelected =
                                                                  true;
                                                            }),
                                                        icon: Ionicons.logo_tux,
                                                        borderColor:
                                                            kBlackColor,
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
                                                                    color:
                                                                        kTextGreyColor.withOpacity(
                                                                            0.4)),
                                                                icon: Icons
                                                                    .description_outlined,
                                                                iconColor:
                                                                    kBlueColor,
                                                                iconBackgroundColor:
                                                                    kBlueColor
                                                                        .withOpacity(
                                                                            0.1),
                                                                title:
                                                                    AppLocalizations.of(context).feature_menu_printed,
                                                                description:
                                                                    AppLocalizations.of(context).feature_menu_printed_description)),
                                                        Stack(
                                                          children: [
                                                            Positioned(
                                                                top: 0,
                                                                right: 0,
                                                                child: Container(
                                                                    padding:
                                                                        pA8,
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
                                                                  setState(
                                                                      () {});
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
                                                                        kPrimaryColor.withOpacity(
                                                                            0.1),
                                                                    title:
                                                                        AppLocalizations.of(context).feature_menu_handwritten,
                                                                    description:
                                                                        AppLocalizations.of(context).feature_menu_handwritten_description)),
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
                                                                      kBlueColor.withOpacity(
                                                                          0.1),
                                                                  title:
                                                                      AppLocalizations.of(context).feature_menu_printed,
                                                                  description:
                                                                      AppLocalizations.of(context).feature_menu_printed_description)),
                                                          h16,
                                                          Stack(
                                                            children: [
                                                              Positioned(
                                                                  top: 0,
                                                                  right: 0,
                                                                  child: Container(
                                                                      padding:
                                                                          pA8,
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
                                                                    isHTR =
                                                                        true;
                                                                    setState(
                                                                        () {});
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
                                                                          kPrimaryColor.withOpacity(
                                                                              0.1),
                                                                      title:
                                                                          AppLocalizations.of(context).feature_menu_handwritten,
                                                                      description:
                                                                          AppLocalizations.of(context).feature_menu_handwritten_description)),
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
                                                                    const BorderRadius.all(
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
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.16,
                                                                          child: Text(
                                                                              result!.files.first.name,
                                                                              style: fB16M),
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
                                                                        width:
                                                                            112,
                                                                        child:
                                                                            DropdownButtonFormField(
                                                                          value:
                                                                              AppLocalizations.of(context).segmentation_button_auto,
                                                                          decoration: InputDecoration(
                                                                              contentPadding: const EdgeInsets.only(left: 12),
                                                                              border: OutlineInputBorder(borderSide: BorderSide(color: kTextGreyColor.withOpacity(0.4)), borderRadius: const BorderRadius.all(Radius.circular(8)))),
                                                                          items: [
                                                                            AppLocalizations.of(context).segmentation_button_auto,
                                                                            AppLocalizations.of(context).segmentation_button_manual
                                                                          ]
                                                                              .map((e) => DropdownMenuItem(
                                                                                    value: e,
                                                                                    child: Text(e),
                                                                                  ))
                                                                              .toList(),
                                                                          onChanged:
                                                                              (e) {
                                                                            isAuto =
                                                                                e == AppLocalizations.of(context).segmentation_button_auto;
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
                                                                            Ionicons.close)),
                                                                  ],
                                                                )
                                                              ],
                                                            )),
                                                        w32,
                                                        CustomElevatedButton(
                                                            onPressed:
                                                                uploadFile,
                                                            child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                      AppLocalizations.of(context).elevated_button_ext),
                                                                  w12,
                                                                  const Icon(Icons
                                                                      .arrow_forward_rounded)
                                                                ])),
                                                      ],
                                                    )
                                                  : Column(
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
                                                                    const BorderRadius.all(
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
                                                                            setState(() {
                                                                              isHTR = false;
                                                                              result = null;
                                                                            });
                                                                          },
                                                                          icon:
                                                                              const Icon(Ionicons.close)),
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
                                                                              Ionicons.document_outline,
                                                                              size: width > 400 ? 32 : 24),
                                                                          width > 400
                                                                              ? w16
                                                                              : w4,
                                                                          Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                            setState(() {
                                                                              isHTR = false;
                                                                              result = null;
                                                                            });
                                                                          },
                                                                          icon:
                                                                              const Icon(Ionicons.close)),
                                                                  ],
                                                                ),
                                                                h8,
                                                                width > 675
                                                                    ? Row(
                                                                        children: [
                                                                          if (isHTR) ...[
                                                                            w16,
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
                                                            onPressed:
                                                                uploadFile,
                                                            child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                      AppLocalizations.of(context).elevated_button_ext),
                                                                  w12,
                                                                  const Icon(Icons
                                                                      .arrow_forward_rounded)
                                                                ])),
                                                      ],
                                                    ),
                                      h64,
                                      if (androidSelected)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Divider(),
                                            h16,
                                            Text(AppLocalizations.of(context).android_install,
                                                style: fB20N),
                                            h16,
                                            Text(
                                                AppLocalizations.of(context).android_install_1,
                                                style: fTG20N),
                                            h4,
                                            Text(
                                                AppLocalizations.of(context).android_install_2,
                                                style: fTG20N),
                                            h4,
                                            Text(
                                                AppLocalizations.of(context).android_install_3,
                                                style: fTG20N),
                                            h4,
                                            Text(
                                                AppLocalizations.of(context).android_install_4,
                                                style: fTG20N),
                                            h4,
                                            Text(
                                                AppLocalizations.of(context).android_install_5,
                                                style: fTG20N),
                                            h4,
                                            Text(
                                                AppLocalizations.of(context).android_install_6,
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
                                            Text(AppLocalizations.of(context).linux_install,
                                                style: fB20N),
                                            h16,
                                            Text(
                                                AppLocalizations.of(context).linux_install_1,
                                                style: fTG20N),
                                            h4,
                                            Text(
                                                AppLocalizations.of(context).linux_install_2,
                                                style: fTG20N),
                                            h4,
                                            Text(
                                                AppLocalizations.of(context).linux_install_3,
                                                style: fTG20N),
                                          ],
                                        ),
                                    ])),
                          )))));
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
                          style: MediaQuery.of(context).size.width > 400
                              ? fMTG32SB
                              : fMP24SB),
                      w4,
                      Text('OCR',
                          style: MediaQuery.of(context).size.width > 400
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
                                Text(AppLocalizations.of(context).home_main_title1,
                                    style: contraint.maxWidth > 1000
                                        ? fB72B
                                        : fB32SB,
                                    textAlign: TextAlign.center),
                                Text(AppLocalizations.of(context).home_main_title2,
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
                                    child: Text(
                                        AppLocalizations.of(context).home_sub_title,
                                        style: fTG20N,
                                        textAlign: TextAlign.center)),
                                h32,
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomWhiteElevatedButton(
                                          onPressed: () => downloadDialog(
                                              width: contraint.maxWidth),
                                          child: Row(
                                            children: [
                                              Text(AppLocalizations.of(context).home_button_1),
                                              w8,
                                              const Icon(
                                                  Icons.file_download_outlined),
                                            ],
                                          )),
                                      w12,
                                      CustomElevatedButton(
                                          child: Text(AppLocalizations.of(context).home_button_2),
                                          onPressed: () => downloadDialog(
                                              width: contraint.maxWidth,
                                              isDownload: false))
                                    ])
                              ]))),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(children: [
                        Text(AppLocalizations.of(context).home_sub_heading,
                            style: contraint.maxWidth > 1000 ? fB64SB : fB32SB,
                            textAlign: TextAlign.center),
                        h8,
                        SizedBox(
                            width: contraint.maxWidth > 1000
                                ? MediaQuery.of(context).size.width * 0.4
                                : MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                                AppLocalizations.of(context).home_sub_description,
                                style: fTG20N,
                                textAlign: TextAlign.center)),
                        h64,
                        if (contraint.maxWidth > 1000)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(children: [
                                  FeatureMenuItem(
                                      title: AppLocalizations.of(context).feature_title_1,
                                      description:
                                          AppLocalizations.of(context).feature_title_desc_1,
                                      icon: Icons.lock_open_rounded,
                                      iconColor: kGreenColor,
                                      iconBackgroundColor:
                                          kGreenColor.withOpacity(0.1)),
                                  h48,
                                  FeatureMenuItem(
                                      title: AppLocalizations.of(context).feature_title_2,
                                      description:
                                          AppLocalizations.of(context).feature_title_desc_2,
                                      icon: Icons.text_fields_rounded,
                                      iconColor: kPinkColor,
                                      iconBackgroundColor:
                                          kPinkColor.withOpacity(0.1))
                                ]),
                                w48,
                                Column(children: [
                                  FeatureMenuItem(
                                      title: AppLocalizations.of(context).feature_title_3,
                                      description:
                                          AppLocalizations.of(context).feature_title_desc_3,
                                      icon: Icons.edit_document,
                                      iconColor: kBlueColor,
                                      iconBackgroundColor:
                                          kBlueColor.withOpacity(0.1)),
                                  h48,
                                  FeatureMenuItem(
                                      title: AppLocalizations.of(context).feature_title_4,
                                      description:
                                          AppLocalizations.of(context).feature_title_desc_4,
                                      icon: Icons.sim_card_download_outlined,
                                      iconColor: kPrimaryColor,
                                      iconBackgroundColor:
                                          kPrimaryColor.withOpacity(0.1))
                                ])
                              ]),
                        if (contraint.maxWidth <= 1000)
                          Column(children: [
                            FeatureMenuItem(
                                title: AppLocalizations.of(context).feature_title_1,
                                description:
                                    AppLocalizations.of(context).feature_title_desc_1,
                                icon: Icons.lock_open_rounded,
                                iconColor: kGreenColor,
                                iconBackgroundColor:
                                    kGreenColor.withOpacity(0.1)),
                            h48,
                            FeatureMenuItem(
                                title: AppLocalizations.of(context).feature_title_2,
                                description:
                                    AppLocalizations.of(context).feature_title_desc_2,
                                icon: Icons.text_fields_rounded,
                                iconColor: kPinkColor,
                                iconBackgroundColor:
                                    kPinkColor.withOpacity(0.1)),
                            h48,
                            FeatureMenuItem(
                                title: AppLocalizations.of(context).feature_title_3,
                                description:
                                    AppLocalizations.of(context).feature_title_desc_3,
                                icon: Icons.edit_document,
                                iconColor: kBlueColor,
                                iconBackgroundColor:
                                    kBlueColor.withOpacity(0.1)),
                            h48,
                            FeatureMenuItem(
                                title: AppLocalizations.of(context).feature_title_4,
                                description:
                                    AppLocalizations.of(context).feature_title_desc_4,
                                icon: Icons.sim_card_download_outlined,
                                iconColor: kPrimaryColor,
                                iconBackgroundColor:
                                    kPrimaryColor.withOpacity(0.1))
                          ]),
                        h256,
                        SizedBox(
                            child: Column(children: [
                          Text(AppLocalizations.of(context).home_head_below_1,
                              style:
                                  contraint.maxWidth > 1000 ? fTG64SB : fTG32SB,
                              textAlign: TextAlign.center),
                          Text(AppLocalizations.of(context).home_head_below_2,
                              style:
                                  contraint.maxWidth > 1000 ? fB64SB : fB32SB,
                              textAlign: TextAlign.center),
                          h24,
                          SizedBox(
                              width: contraint.maxWidth > 1000
                                  ? MediaQuery.of(context).size.width * 0.6
                                  : MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                  AppLocalizations.of(context).home_below_description,
                                  style: fB20N,
                                  textAlign: TextAlign.center)),
                          h32,
                          CustomElevatedButton(
                              onPressed: () => _launchUrl(_icfossURL),
                              child: Text(AppLocalizations.of(context).home_below_button))
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
                                    Text('Powered By', style: fTG20N),
                                    Text('ICFOSS', style: fB32SB)
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
