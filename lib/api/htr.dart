import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:htr/api/api.dart';
import 'package:htr/models/htr.dart';
import 'package:http_parser/http_parser.dart';

final dio = Dio(baseOptions);

Future<HTRModel?> uploadHTR(File file) async {
  String fileName = file.path.split('/').last;
  FormData formData = FormData.fromMap({
    "filename": fileName,
    "threshold_value": 80,
    "dilate_x_value": 1,
    "dilate_y_value": 20,
    "file": await MultipartFile.fromFile(file.path,
        filename: fileName, contentType: MediaType('application', 'pdf')),
  });
  try {
    final response = await dio.post("/api/document/post", data: formData);
    if (response.statusCode == 200) {
      return HTRModel.fromJson(response.data);
    } else {
      log('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode!;
    }
  } catch (error) {
    log(error.toString());
  }
  return null;
}

Future<HTRModel?> uploadHTRWeb(
  fileBytes,
  fileName,
) async {
  FormData formData = FormData.fromMap({
    "filename": fileName,
    "threshold_value": 80,
    "dilate_x_value": 1,
    "dilate_y_value": 20,
    "file": MultipartFile.fromBytes(fileBytes,
        filename: fileName, contentType: MediaType('application', 'pdf')),
  });
  try {
    log(formData.fields.toString());
    final response = await dio.post("/api/document/post", data: formData);
    if (response.statusCode == 200) {
      return HTRModel.fromJson(response.data);
    } else {
      log('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode!;
    }
  } catch (error) {
    log(error.toString());
  }
  return null;
}
