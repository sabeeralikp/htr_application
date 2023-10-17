import 'package:dhriti/models/upload_ocr.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;

class OCRResultModel {
  UploadOCRModel? ocr;
  fq.QuillController? quillController;
  OCRResultModel({this.ocr, this.quillController});
}
