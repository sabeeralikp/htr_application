import 'package:flutter/material.dart';
import 'package:htr/config/buttons/button_themes.dart';
import 'package:htr/config/colors/colors.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/measures/gap.dart';
import 'package:htr/config/measures/padding.dart';
import 'package:htr/providers/locale_provider.dart';
import 'package:htr/routes/route.dart';
import 'package:htr/screens/home/home.dart';
export 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                padding: pA16,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
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
                          child: Text("Document Extractor", style: fB16M)),
                      h16,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MenuChild(
                              icon: Icons.cloud_off_rounded,
                              title: 'Digital',
                              description: '(offline)',
                              iconColor: kGreenColor,
                              onTap: () => navigateToOCR(context, true)),
                          MenuChild(
                              icon: Icons.description_outlined,
                              title: 'Digital',
                              description: '(online)',
                              iconColor: kBlueColor,
                              onTap: () => navigateToOCR(context, false)),
                          MenuChild(
                              icon: Icons.draw_rounded,
                              title: 'Handwriting',
                              description: '(beta)',
                              iconColor: kPurpleColor,
                              onTap: () => navigateToHTR(context)),
                        ],
                      )
                    ]),
              ),
              h8,
              Stack(
                children: [
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
                              child: Text("Document Utilities", style: fTG16M)),
                          h16,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MenuChild(
                                  icon: Icons.translate_outlined,
                                  title: 'Translate',
                                  // description: 'Documents',
                                  iconColor: kTextGreyColor,
                                  onTap: () {}),
                              MenuChild(
                                  icon: Icons.short_text_outlined,
                                  title: 'Summerize',
                                  // description: 'Summerizer',
                                  iconColor: kTextGreyColor,
                                  onTap: () {}),
                              MenuChild(
                                  icon: Icons.mic_none_outlined,
                                  title: 'Speech',
                                  // description: 'Documents',
                                  iconColor: kTextGreyColor,
                                  onTap: () {}),
                            ],
                          )
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
                          child: Text('Coming Soon', style: fW16N)))
                ],
              )
            ])));
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
