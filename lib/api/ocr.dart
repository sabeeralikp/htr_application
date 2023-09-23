import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:htr/models/upload_ocr.dart';
import 'package:http_parser/http_parser.dart';
import 'api.dart';

///
/// [integrating OCR to HTR]
///
/// [author] Sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	(August 17th, 2023 10:18 AM)
///
final dio = Dio(baseOptions);

/// Uploads Optical Character Recognition (OCR) data to the Django backend.
///
/// [file]: The File object representing the OCR data to be uploaded.
///
/// Returns: An `UploadOCRModel` object representing the uploaded data, or null if there's an error.
Future<UploadOCRModel?> uploadOCR(File file) async {
  // Extract the filename from the file path.
  String fileName = file.path.split('/').last;
  log(fileName);
  // Create FormData for the HTTP POST request.
  FormData formData = FormData.fromMap({
    "filename": fileName,
    "file": await MultipartFile.fromFile(file.path,
        filename: fileName,
        contentType: file.uri.pathSegments.last.split('.').last == 'pdf'
            ? MediaType('application', 'pdf')
            : MediaType('image', file.uri.pathSegments.last.split('.').last)),
  });
  try {
    final response = await dio.post("/api/document/upload", data: formData);
    if (response.statusCode == 200) {
      return UploadOCRModel.fromJson(response.data);
    } else {
      log('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode!;
    }
  } catch (error) {
    log(error.toString());
  }
  return null;
}

/// Uploads Optical Character Recognition (OCR) data to the Django backend (for web).
///
/// [fileBytes]: The bytes representing the OCR data to be uploaded.
/// [fileName]: The filename of the OCR data.
///
/// Returns: An `UploadOCRModel` object representing the uploaded data, or null if there's an error.
Future<UploadOCRModel?> uploadOCRWeb(
  fileBytes,
  fileName,
) async {
  // Create FormData for the HTTP POST request.
  FormData formData = FormData.fromMap({
    "filename": fileName,
    "file": MultipartFile.fromBytes(fileBytes,
        filename: fileName,
        contentType: fileName.split('.').last == 'pdf'
            ? MediaType('application', 'pdf')
            : MediaType('image', fileName.split('.').last)),
  });
  try {
    log(formData.fields.toString());
    final response = await dio.post("/api/document/upload", data: formData);
    if (response.statusCode == 200) {
      return UploadOCRModel.fromJson(response.data);
    } else {
      log('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode!;
    }
  } catch (error) {
    log(error.toString());
  }
  return null;
}

/// Extracts text from a PDF page using OCR data.
///
/// [pageNumber]: The page number from which to extract text.
/// [ocrID]: The OCR identifier associated with the page.
///
/// Returns: A string containing the extracted text, or null if there's an error.
Future<String?> extractText(int pageNumber, int ocrID) async {
  // Create FormData for the HTTP POST request.
  FormData formData =
      FormData.fromMap({"upload_ocr_id": ocrID, "page_number": pageNumber});
  try {
    final response =
        await dio.post("/api/document/extract_pdf", data: formData);
    if (response.statusCode == 200) {
      return response.data['text'];
    } else {
      log('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode!;
    }
  } catch (error) {
    log(error.toString());
  }
  return null;
}
