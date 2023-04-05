class SaveDataModel {
  int? imageCordinate;
  String? annotatedText;

  SaveDataModel({this.imageCordinate, this.annotatedText});
  SaveDataModel.fromJson(Map<String, dynamic> json) {
    imageCordinate = json['image_cordinate'].toInt();
    annotatedText = json['annotated_text'].toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image_cordinate'] = imageCordinate;
    data['annotated_text'] = annotatedText;
    return data;
  }

  static List<SaveDataModel> listFromJson(List<dynamic> list) {
    List<SaveDataModel> rows =
        list.map((i) => SaveDataModel.fromJson(i)).toList();
    return rows;
  }
}
