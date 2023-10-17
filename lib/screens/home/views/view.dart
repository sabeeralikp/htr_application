import 'package:flutter/material.dart';
import 'package:dhriti/config/buttons/button_themes.dart';
import 'package:dhriti/config/colors/colors.dart';
import 'package:dhriti/config/fonts/fonts.dart';
import 'package:dhriti/config/measures/gap.dart';
import 'package:dhriti/config/measures/padding.dart';
import 'package:dhriti/providers/locale_provider.dart';
import 'package:dhriti/routes/route.dart';
import 'package:dhriti/screens/home/home.dart';
import 'package:ionicons/ionicons.dart';
export 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  navigateToHTR(context) {
    Navigator.of(context).pushNamed(RouteProvider.htrHome);
  }

  navigateToOCR(context, bool? isOffline) {
    Navigator.of(context)
        .pushNamed(RouteProvider.ocrHome, arguments: isOffline);
  }

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

  /// Launches a URL in the device's default web browser.
  ///
  /// Throws an exception if the URL cannot be launched.
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $_icfossURL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                // Title text "ധൃതി" with font size based on screen width
                Text('ധൃതി', style: fMP24SB),
                w4,
                // Subtitle text "OCR" with font size based on screen width
                Text('OCR', style: fTG24SB)
              ]),
          actions: [
            CustomWhiteElevatedButton(
                child: Row(
                  children: [
                    const Icon(Icons.translate_rounded),
                    w8,
                    Text(
                        Provider.of<LocaleProvider>(context, listen: false)
                                    .locale ==
                                AppLocalizations.supportedLocales[0]
                            ? 'മലയാളം'
                            : 'English',
                        style:
                            Provider.of<LocaleProvider>(context, listen: false)
                                        .locale ==
                                    AppLocalizations.supportedLocales[0]
                                ? fMB16SB
                                : null),
                  ],
                ),
                onPressed: () {
                  Provider.of<LocaleProvider>(context, listen: false)
                      .changeLocale();
                  setState(() {});
                }),
            w8,
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    padding: pA16,
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: -1,
                              blurRadius: 2,
                              color: Colors.black.withOpacity(.4))
                        ]),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(AppLocalizations.of(context)!.box_title_1, style: fB16M)),
                          h16,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MenuChild(
                                  icon: Icons.cloud_off_rounded,
                                  title: AppLocalizations.of(context)!.menu_title_1,
                                  description: AppLocalizations.of(context)!.description_title_1,
                                  iconColor: kGreenColor,
                                  onTap: () => navigateToOCR(context, true)),
                              MenuChild(
                                  icon: Icons.description_outlined,
                                  title: AppLocalizations.of(context)!.menu_title_1,
                                  description: AppLocalizations.of(context)!.description_title_2,
                                  iconColor: kBlueColor,
                                  onTap: () => navigateToOCR(context, false)),
                              MenuChild(
                                  icon: Icons.draw_rounded,
                                  title: AppLocalizations.of(context)!.menu_title_2,
                                  description: AppLocalizations.of(context)!.description_title_3,
                                  iconColor: kPurpleColor,
                                  onTap: () => navigateToHTR(context)),
                            ],
                          ),
                          h8,
                        ]),
                  ),
                  h8,
                  Stack(
                    children: [
                      Container(
                        padding: pA16,
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: -1,
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(.4))
                            ]),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(AppLocalizations.of(context)!.box_title_2,
                                      style: fTG16M)),
                              h16,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  MenuChild(
                                      icon: Icons.translate_outlined,
                                      title: AppLocalizations.of(context)!.menu_title_3,
                                      // description: 'Documents',
                                      iconColor: kTextGreyColor,
                                      onTap: () {}),
                                  MenuChild(
                                      icon: Icons.short_text_outlined,
                                      title: AppLocalizations.of(context)!.menu_title_4,
                                      // description: 'Summerizer',
                                      iconColor: kTextGreyColor,
                                      onTap: () {}),
                                  MenuChild(
                                      icon: Icons.mic_none_outlined,
                                      title: AppLocalizations.of(context)!.menu_title_5,
                                      // description: 'Documents',
                                      iconColor: kTextGreyColor,
                                      onTap: () {}),
                                ],
                              ),
                              h8,
                            ]),
                      ),
                      Positioned(
                          top: 4,
                          right: 16,
                          child: Container(
                              padding: pA8,
                              decoration: BoxDecoration(
                                  color: kTextGreyColor.withOpacity(0.3),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomLeft: Radius.circular(16))),
                              child: Text(AppLocalizations.of(context)!.child_text, style: fW16N)))
                    ],
                  ),
                ]),
                Column(
                  children: [
                    Divider(color: kTextGreyColor.withOpacity(0.1)),
                    h8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Powered By', style: fTG14M),
                            // Text('LT Team', style: fB14N),
                            Text('ICFOSS', style: fB24SB),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Tooltip(
                                    // Tooltip widget with an IconButton to launch Gitlab URL.
                                    message: 'Gitlab',
                                    child: IconButton(
                                        onPressed: () => _launchUrl(_gitlabURL),
                                        icon:
                                            const Icon(Ionicons.logo_gitlab))),
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
                            Row(
                              children: [
                                Tooltip(
                                    // Tooltip widget with an IconButton to launch icfoss.in URL.
                                    message: 'icfoss.in',
                                    child: IconButton(
                                        onPressed: () => _launchUrl(_icfossURL),
                                        icon: const Icon(
                                            Icons.language_rounded))),
                                w8,
                                Tooltip(
                                    // Tooltip widget with an IconButton to launch Youtube URL
                                    message: 'Youtube',
                                    child: IconButton(
                                        onPressed: () =>
                                            _launchUrl(_youtubeURL),
                                        icon:
                                            const Icon(Ionicons.logo_youtube)))
                              ],
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ],
            )));
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

class MenuChild extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final VoidCallback onTap;
  final Color iconColor;
  const MenuChild(
      {required this.icon,
      required this.title,
      this.description,
      required this.onTap,
      required this.iconColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  padding: pA16,
                  decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      border: Border.all(color: iconColor.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(icon, size: 28, color: iconColor)),
              // w12,
              h12,
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text(title, style: fB14M),
                if (description != null) Text(description ?? "", style: fTG12N),
                // h4,
                // SizedBox(
                //     width: MediaQuery.of(context).size.width * 0.62,
                //     child: Text(description, style: fTG14N))
              ])
            ]));
  }
}
