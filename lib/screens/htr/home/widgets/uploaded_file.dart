import 'package:flutter/material.dart';
import 'package:htr/config/assets/assets.dart';
import 'package:htr/config/decorations/box.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/icons/icons.dart';
import 'package:htr/config/measures/padding.dart';
import 'package:htr/config/measures/visual_density.dart';
import 'package:htr/models/upload_htr.dart';
import 'package:timeago/timeago.dart' as timeago;

///
/// [UploadedFileContainer]
///
/// [author] Sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	May 26th, 2023 11:59 AM
/// [see]		StatelessWidget
///
/// A stateless widget representing the container for an uploaded file.
///
/// [htr] is an instance of the [UploadHTRModel] representing the uploaded file.
/// [removeHTR] is a callback function to remove the uploaded file.
/// [key] is an optional parameter to provide a key for the widget.
///
/// Returns a widget that displays the container for an uploaded file.
class UploadedFileContainer extends StatelessWidget {
  final UploadHTRModel htr;
  final Function() removeHTR;
  const UploadedFileContainer(
      {super.key, required this.htr, required this.removeHTR});

  /// Builds the widget tree for the container of an uploaded file.
  ///
  /// [context] is the build context.
  ///
  /// Returns a [Container] widget that contains the following properties:
  ///   - [padding] sets the padding of the container to [pA8].
  ///   - [decoration] applies a border with a width of 8 using [bDW8].
  ///   - [width] sets the width of the container to 250.
  ///   - [child] contains a [Column] widget with the following properties:
  ///     - [mainAxisSize] sets the vertical size of the column to [MainAxisSize.min].
  ///     - [mainAxisAlignment] aligns the children at the start of the column.
  ///     - [crossAxisAlignment] aligns the children at the start of each row.
  ///     - [children] is a list of widgets including:
  ///       - [ListTile] widget displaying the uploaded file information, including:
  ///         - [leading] displays a square container with dimensions 48x48 containing [pdfFileIcon].
  ///         - [visualDensity] sets the visual density of the list tile to [vDn4n4].
  ///         - [contentPadding] sets the content padding of the list tile to [p0].
  ///         - [title] displays the filename obtained from [htr] using [fP16M] style.
  ///         - [subtitle] displays the formatted uploaded time obtained from [htr] using [fG14N] style.
  ///         - [trailing] displays a clickable container containing [iCloseR18].
  ///           The [removeHTR] callback is invoked when the container is tapped.

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: pA8,
        decoration: bDW8,
        width: 250,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                  leading: SizedBox(width: 48, height: 48, child: pdfFileIcon),
                  visualDensity: vDn4n4,
                  contentPadding: p0,
                  title: Text(htr.filename!, style: fP16M),
                  subtitle: Text(
                      timeago.format(DateTime.parse(htr.uploadedOn!)),
                      style: fG14N),
                  trailing: InkWell(
                      onTap: removeHTR,
                      child: Container(
                          padding: pA4,
                          decoration: bDR50b075,
                          child: iCloseR18)))
            ]));
  }
}
