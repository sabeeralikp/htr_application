import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:htr/api/api.dart';
import 'package:htr/models/cordinates.dart';
import 'package:htr/models/upload_htr.dart';
import 'package:http_parser/http_parser.dart';

final dio = Dio(baseOptions);

Future<UploadHTRModel?> uploadHTR(File file) async {
  String fileName = file.path.split('/').last;
  FormData formData = FormData.fromMap({
    "filename": fileName,
    "file": await MultipartFile.fromFile(file.path,
        filename: fileName, contentType: MediaType('application', 'pdf')),
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

Future<UploadHTRModel?> uploadHTRWeb(
  fileBytes,
  fileName,
) async {
  FormData formData = FormData.fromMap({
    "filename": fileName,
    "file": MultipartFile.fromBytes(fileBytes,
        filename: fileName, contentType: MediaType('application', 'pdf')),
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

Future<List<Cordinates>> postThresholdValues(
    threshold, dilateX, dilateY, uploadHTR) async {
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
