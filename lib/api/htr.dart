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

final dio = Dio(baseOptions);

Future<UploadHTRModel?> uploadHTR(File file) async {
  String fileName = file.path.split('/').last;
  log(fileName);
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

Future<UploadHTRModel?> uploadHTRWeb(
  fileBytes,
  fileName,
) async {
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

Future<List<Cordinates>> postAutoSegmentationValues(uploadHTR) async {
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

Future<List<dynamic>> postExtractText(
    List<Cordinates> cordinates, uploadHTR) async {
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

Future<List<dynamic>> postSaveData(List<SaveDataModel> saveDatas) async {
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

Future<String?> exportAsDOC(File file) async {
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

Future<String?> exportAsDOCWeb(fileBytes, fileName) async {
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

Future<FeedbackModel?> postFeedBack(
    int uploadHTR, double? raiting, String remarks) async {
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
