
class FeedbackModel {
  int? uploadHtr;
  double? raiting;
  String? remarks;
  String? createdOn;
  dynamic createdBy;

  FeedbackModel({this.uploadHtr, this.raiting, this.remarks, this.createdOn, this.createdBy});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    uploadHtr = json["upload_htr"];
    raiting = json["raiting"];
    remarks = json["remarks"];
    createdOn = json["created_on"];
    createdBy = json["created_by"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["upload_htr"] = uploadHtr;
    data["raiting"] = raiting;
    data["remarks"] = remarks;
    data["created_on"] = createdOn;
    data["created_by"] = createdBy;
    return data;
  }
}