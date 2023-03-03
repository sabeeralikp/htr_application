import 'package:flutter/material.dart';
import 'package:htr/config/assets/assets.dart';
import 'package:htr/config/fonts/fonts.dart';
import 'package:htr/config/measures/gap.dart';

class UploadFileBody extends StatelessWidget {
  const UploadFileBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        fileUploadSVG,
        h18,
        Text('UPLOAD FILE', style: p16SB),
        h4,
        Text('Upload your pdf or image', style: p7014L),
      ],
    );
  }
}
