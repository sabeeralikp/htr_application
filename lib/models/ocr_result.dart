/// 
/// [printed with ocr integrated]
///
/// [author] Sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	(August 17th, 2023 12:32 PM) 
///
/// The `OCRResultModel` class represents OCR (Optical Character Recognition) result data
/// in the Flutter application.
///
/// This class combines an `UploadOCRModel` object with a `fq.QuillController` object to
/// store and manage OCR result data and associated rich text content.
///
/// Attributes:
///   - [ocr]: An optional `UploadOCRModel` object representing the OCR data associated with
///            this result.
///   - [quillController]: An optional `fq.QuillController` object for managing rich text content
///                       associated with the OCR result.
///
/// Constructors:
///   - [OCRResultModel]: Initializes an `OCRResultModel` object with optional parameters.
///       - [ocr]: The OCR data associated with this result.
///       - [quillController]: The Quill controller for rich text content.
import 'package:htr/models/upload_ocr.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;

class OCRResultModel {
  UploadOCRModel? ocr;
  fq.QuillController? quillController;
  /// Constructs an `OCRResultModel` object with optional parameters.
  OCRResultModel({this.ocr, this.quillController});
}
