import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:htr/api/api.dart';
import 'package:htr/models/cordinates.dart';
import 'package:htr/models/feedback_model.dart';
import 'package:htr/models/save_data.dart';
import 'package:htr/models/upload_htr.dart';
import 'package:http_parser/http_parser.dart';
/// 
/// [Changes in Segment page]
///
/// [author] Sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	(March 21st, 2023 3:02 PM) 
///

final dio = Dio(baseOptions);
/// Uploads Handwriting Text Recognition (HTR) data to the Django backend.
///
/// [file]: The File object representing the HTR data to be uploaded.
///
/// Returns: An `UploadHTRModel` object representing the uploaded data, or null if there's an error.
Future<UploadHTRModel?> uploadHTR(File file) async {
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
    final response = await dio.post("/api/document/postHTR", data: formData);
    if (response.statusCode == 200) {
      return UploadHTRModel.fromJson(response.data);
    } else {
      log('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode!;
    }
  } catch (error) {
    log(error.toString());
  }
  return null;
}
/// Uploads Handwriting Text Recognition (HTR) data to the Django backend (for web).
///
/// [fileBytes]: The bytes representing the HTR data to be uploaded.
/// [fileName]: The filename of the HTR data.
///
/// Returns: An `UploadHTRModel` object representing the uploaded data, or null if there's an error.
Future<UploadHTRModel?> uploadHTRWeb(
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
    final response = await dio.post("/api/document/postHTR", data: formData);
    if (response.statusCode == 200) {
      return UploadHTRModel.fromJson(response.data);
    } else {
      log('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode!;
    }
  } catch (error) {
    log(error.toString());
  }
  return null;
}
/// Posts threshold values, dilation values, and uploadHTR data to the Django backend.
///
/// [threshold]: The threshold value.
/// [dilateX]: The dilation value in the X-axis.
/// [dilateY]: The dilation value in the Y-axis.
/// [uploadHTR]: The uploadHTR identifier.
///
/// Returns: A list of `Cordinates` representing the result data, or an empty list if there's an error.
Future<List<Cordinates>> postThresholdValues(
    threshold, dilateX, dilateY, uploadHTR) async {
  // Create FormData for the HTTP POST request.
  FormData formData = FormData.fromMap({
    "threshold": threshold.toInt(),
    "dilate_x": dilateX.toInt(),
    "dilate_y": dilateY.toInt(),
    "upload_htr": uploadHTR
  });
  try {
    final response = await dio.post("/api/document/threshold", data: formData);
    if (response.statusCode == 200) {
      return Cordinates.listFromJson(response.data);
    } else {
      log('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode!;
    }
  } catch (error) {
    log(error.toString());
  }
  return [];
}
/// Posts auto-segmentation values and uploadHTR data to the Django backend.
///
/// [uploadHTR]: The uploadHTR identifier.
///
/// Returns: A list of `Cordinates` representing the result data, or an empty list if there's an error.

Future<List<Cordinates>> postAutoSegmentationValues(uploadHTR) async {
  // Create FormData for the HTTP POST request.
  FormData formData = FormData.fromMap({"upload_htr": uploadHTR});
  try {
    final response =
        await dio.post("/api/document/autoSegment", data: formData);
    if (response.statusCode == 200) {
      return Cordinates.listFromJson(response.data);
    } else {
      log('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode!;
    }
  } catch (error) {
    log(error.toString());
  }
  return [];
}
/// Posts coordinates and uploadHTR data to the Django backend for text extraction.
///
/// [cordinates]: A list of `Cordinates` representing the text coordinates.
/// [uploadHTR]: The uploadHTR identifier.
///
/// Returns: A list of dynamic data representing the extracted text, or an empty list if there's an error.
Future<List<dynamic>> postExtractText(
    List<Cordinates> cordinates, uploadHTR) async {
  // Create FormData for the HTTP POST request.
  FormData formData = FormData.fromMap(
      {"cordinates": jsonEncode(cordinates), "upload_htr": uploadHTR});
  try {
    final response = await dio.post("/api/document/extract", data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      log('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode!;
    }
  } catch (error) {
    log(error.toString());
  }
  return [];
}
/// Posts saved data to the Django backend.
///
/// [saveDatas]: A list of `SaveDataModel` representing saved data.
///
/// Returns: A list of dynamic data representing the saved data, or an empty list if there's an error.

Future<List<dynamic>> postSaveData(List<SaveDataModel> saveDatas) async {
  // Create FormData for the HTTP POST request.
  FormData formData = FormData.fromMap({"datas": jsonEncode(saveDatas)});
  try {
    final response = await dio.post("/api/document/saveData", data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      log('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode!;
    }
  } catch (error) {
    log(error.toString());
  }
  return [];
}
/// Exports data as DOC format to the Django backend.
///
/// [file]: The File object representing the data to be exported.
///
/// Returns: A string representing the exported data, or null if there's an error.
Future<String?> exportAsDOC(File file) async {
  // Create FormData for the HTTP POST request.
  FormData formData = FormData.fromMap({
    "file": await MultipartFile.fromFile(file.path),
  });
  try {
    final response = await dio.post("/api/document/exportDoc", data: formData);
    if (response.statusCode == 200) {
      return response.data["file"];
    } else {
      log('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode!;
    }
  } catch (error) {
    log(error.toString());
  }
  return null;
}
/// Posts feedback data to the Django backend.
///
/// [uploadHTR]: The uploadHTR identifier.
/// [raiting]: The rating for the feedback.
/// [remarks]: The remarks for the feedback.
///
/// Returns: A `FeedbackModel` representing the feedback data, or null if there's an error.
Future<FeedbackModel?> postFeedBack(
    int uploadHTR, double? raiting, String remarks) async {
  // Create FormData for the HTTP POST request.
  FormData formData = FormData.fromMap(
      {'upload_htr': uploadHTR, 'raiting': raiting, 'remarks': remarks});
  try {
    final response = await dio.post("/api/document/feedback", data: formData);
    if (response.statusCode == 200) {
      return response.data["file"];
    } else {
      log('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode!;
    }
  } catch (error) {
    log(error.toString());
  }
  return null;
}
/// Exports data as DOC format to the Django backend (for web).
///
/// [fileBytes]: The bytes representing the data to be exported.
/// [fileName]: The filename of the data.
///
/// Returns: A string representing the exported data, or null if there's an error.
Future<String?> exportAsDOCWeb(fileBytes, fileName) async {
  // Create FormData for the HTTP POST request.
  FormData formData = FormData.fromMap({
    "file": MultipartFile.fromBytes(fileBytes,
        filename: fileName, contentType: MediaType('application', 'pdf')),
  });
  try {
    final response = await dio.post("/api/document/exportDoc", data: formData);
    if (response.statusCode == 200) {
      return response.data["file"];
    } else {
      log('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode!;
    }
  } catch (error) {
    log(error.toString());
  }
  return null;
}
