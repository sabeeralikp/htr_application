import 'package:flutter/material.dart';
import 'package:htr/config/assets/assets.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/measures/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///
/// [UploadFileBody]
///
/// [author] Sabeerali
/// [since] v0.0.1
/// [version]	v1.0.0	March 3rd, 2023 10:32 AM
/// [see]		StatelessWidget
///
/// A stateless widget representing the body of the upload file screen.
///
/// [key] is an optional parameter to provide a key for the widget.
///
/// Returns a widget that displays the upload file screen body.
class UploadFileBody extends StatelessWidget {
  const UploadFileBody({
    super.key,
  });

  /// Builds the widget tree for the upload file screen body.
  ///
  /// [context] is the build context.
  ///
  /// Returns a [Center] widget that centers its child vertically and horizontally.
  /// The child is a [Column] widget that contains the following widgets in order:
  ///   - [fileUploadSVG] displays an SVG image for file upload.
  ///   - [Text] widget displaying the title text obtained from the app's localized resources.
  ///     The text style is specified by [fP16SB], and the text is centered.
  ///   - [h4] provides a vertical spacing.
  ///   - [Text] widget displaying the description text obtained from the app's localized resources.
  ///     The text style is specified by [fP7014L], and the text is centered.
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          fileUploadSVG,
          Text(AppLocalizations.of(context).home_body_title,
              style: fP16SB, textAlign: TextAlign.center),
          h4,
          Text(AppLocalizations.of(context).home_body_description,
              style: fP7014L, textAlign: TextAlign.center)
        ]));
  }
}
