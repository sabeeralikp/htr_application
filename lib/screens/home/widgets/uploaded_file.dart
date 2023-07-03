import 'package:flutter/material.dart';
import 'package:htr/config/assets/assets.dart';
import 'package:htr/config/decorations/box.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/icons/icons.dart';
import 'package:htr/config/measures/padding.dart';
import 'package:htr/config/measures/visual_density.dart';
import 'package:htr/models/upload_htr.dart';
import 'package:timeago/timeago.dart' as timeago;

class UploadedFileContainer extends StatelessWidget {
  final UploadHTRModel htr;
  final Function() removeHTR;
  const UploadedFileContainer(
      {super.key, required this.htr, required this.removeHTR});

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
