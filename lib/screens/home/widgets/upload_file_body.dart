import 'package:flutter/material.dart';
import 'package:htr/config/assets/assets.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/measures/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UploadFileBody extends StatelessWidget {
  const UploadFileBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        fileUploadSVG,
        Text(AppLocalizations.of(context).home_body_title,
            style: fP16SB, textAlign: TextAlign.center),
        h4,
        Text(AppLocalizations.of(context).home_body_description,
            style: fP7014L, textAlign: TextAlign.center),
      ],
    );
  }
}
