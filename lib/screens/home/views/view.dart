import 'package:flutter/material.dart';
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

  navigateToOCR(context) {
    Navigator.of(context).pushNamed(RouteProvider.ocrHome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfff8f8f8),
        appBar: AppBar(title: const Text('ധൃതി OCR'), actions: [
          TextButton(
              onPressed: () {
                Provider.of<LocaleProvider>(context, listen: false)
                    .changeLocale();
                setState(() {});
              },
              child: Row(children: [
                const Icon(Icons.translate_rounded),
                w8,
                Text(Provider.of<LocaleProvider>(context, listen: false)
                            .locale ==
                        AppLocalizations.supportedLocales[0]
                    ? 'മലയാളം'
                    : 'English')
              ]))
        ]),
        body: LayoutBuilder(builder: (context, contraint) {
          if (contraint.maxWidth < 700) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: pA8,
                      child: Text('Text Extractor', style: fP16SB)),
                  MenuChild(
                      icon: Icons.description_rounded,
                      title: 'Printed',
                      description:
                          'Extract and transcribe text from Malayalam - English documents',
                      onTap: () => navigateToOCR(context)),
                  MenuChild(
                      icon: Icons.document_scanner_rounded,
                      title: 'Handwritten',
                      description:
                          'Capture and convert handwritten content in Malayalam',
                      onTap: () => navigateToHTR(context))
                ]);
          } else {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding:
                          const EdgeInsets.only(top: 16, bottom: 8, left: 16),
                      child: Text('Text Extractor', style: fP16SB)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MenuChildLarge(
                        onTap: () => navigateToOCR(context),
                        icon: Icons.description_rounded,
                        title: 'Printed Document',
                        description:
                            'Specialized software tool designed to accurately extract and transcribe text content from printed documents written in the Malayalam language. It employs advanced optical character recognition (OCR) technology to convert scanned or photographed documents into editable and searchable digital text',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MenuChildLarge(
                        onTap: () => navigateToHTR(context),
                        icon: Icons.document_scanner_rounded,
                        title: 'Handwritten Document',
                        description:
                            'Innovative software solution designed to capture and convert handwritten content in the Malayalam language into digital text. Utilizing advanced handwriting recognition technology, this tool enables the transformation of handwritten documents, notes, or texts into editable and searchable formats.',
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        }));
  }
}

class MenuChildLarge extends StatelessWidget {
  final IconData icon;
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
              Icon(icon, size: 108, color: kPrimaryColor),
              w8,
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: fP16M),
                h4,
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.38,
                  child: Text(description, style: fG14N),
                )
              ])
            ])));
  }
}

class MenuChild extends StatelessWidget {
  final IconData icon;
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
            Icon(icon, size: 48, color: kPrimaryColor),
            w8,
            Flexible(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title, style: fP16M),
                  h4,
                  Text(description, style: fG14N)
                ]))
          ]),
        ));
  }
}
