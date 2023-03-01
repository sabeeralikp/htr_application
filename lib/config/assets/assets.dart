import 'package:flutter_svg/svg.dart';

// Background
const String fileUploadPath = 'assets/background/file_upload.svg';

// Custom Icons
const String cloudUploadPath = 'assets/icons/cloud_upload.svg';

// Background
final SvgPicture fileUploadSVG = SvgPicture.asset(
  fileUploadPath,
  semanticsLabel: 'File Upload SVG',
);

// Custom Icons
final SvgPicture cloudUploadIcon = SvgPicture.asset(
  cloudUploadPath,
  semanticsLabel: 'Cloud Upload SVG',
);
