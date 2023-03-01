class HTRModel {
  int? id;
  String? filename;
  String? file;
  String? extractedText;
  int? thresholdValue;
  int? dilateXValue;
  int? dilateYValue;
  String? uploadedBy;
  DateTime? uploadedOn;

  HTRModel({this.id, this.filename, this.file, this.uploadedBy});

  HTRModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    filename = json['filename'];
    file = json['file'];
    extractedText = json['extracted_text'];
    dilateXValue = json['dilate_x_value'];
    dilateYValue = json['dilate_y_value'];
    uploadedBy = json['uploaded_by'];
    uploadedOn = DateTime.parse(json['uploaded_on']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['filename'] = filename;
    data['file'] = file;
    data['extracted_text'] = extractedText;
    data['dilate_x_value'] = dilateXValue;
    data['dilate_y_value'] = dilateYValue;
    data['uploaded_by'] = uploadedBy;
    data['uploaded_on'] = uploadedOn;
    return data;
  }

  static List<HTRModel> listFromJson(List<dynamic> list) {
    List<HTRModel> rows = list.map((i) => HTRModel.fromJson(i)).toList();
    return rows;
  }
}
