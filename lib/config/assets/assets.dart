import 'package:flutter_svg/svg.dart';

// Background
const String fileUploadPath = 'assets/background/file_upload.svg';
const String fileUploadOCRPath = 'assets/background/file_upload_ocr.svg';

// Custom Icons
const String cloudUploadPath = 'assets/icons/cloud_upload.svg';

const String pdfFilePath = 'assets/icons/pdf.svg';
const String htrFilePath = 'assets/icons/HTR.svg';
const String htrSmallFilePath = 'assets/icons/htr_small.svg';
const String ocrSmallFilePath = 'assets/icons/ocr_small.svg';
const String ocrFilePath = 'assets/icons/OCR.svg';

// Background
final SvgPicture fileUploadSVG =
    SvgPicture.asset(fileUploadPath, semanticsLabel: 'File Upload SVG');

final SvgPicture fileUploadOCRSVG =
    SvgPicture.asset(fileUploadOCRPath, semanticsLabel: 'File Upload SVG');

// Custom Icons
final SvgPicture cloudUploadIcon =
    SvgPicture.asset(cloudUploadPath, semanticsLabel: 'Cloud Upload SVG');

final SvgPicture pdfFileIcon =
    SvgPicture.asset(pdfFilePath, semanticsLabel: 'PDF File SVG');
final SvgPicture htrIcon =
    SvgPicture.asset(htrFilePath, semanticsLabel: 'HTR SVG');
final SvgPicture ocrIcon =
    SvgPicture.asset(ocrFilePath, semanticsLabel: 'OCR SVG');
final SvgPicture htrSmallIcon =
    SvgPicture.asset(htrSmallFilePath, semanticsLabel: 'HTR Small SVG');
final SvgPicture ocrSmallIcon =
    SvgPicture.asset(ocrSmallFilePath, semanticsLabel: 'OCR Small SVG');
