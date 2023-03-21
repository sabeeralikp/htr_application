class UploadHTRModel {
  int? id;
  String? filename;
  String? file;
  String? fileType;
  int? numberOfPages;
  String? uploadedBy;
  String? uploadedOn;

  UploadHTRModel(
      {this.id,
      this.filename,
      this.file,
      this.fileType,
      this.numberOfPages,
      this.uploadedBy,
      this.uploadedOn});

  UploadHTRModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    filename = json['filename'];
    file = json['file'];
    fileType = json['file_type'];
    numberOfPages = json['number_of_pages'];
    uploadedBy = json['uploaded_by'];
    uploadedOn = json['uploaded_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['filename'] = filename;
    data['file'] = file;
    data['file_type'] = fileType;
    data['number_of_pages'] = numberOfPages;
    data['uploaded_by'] = uploadedBy;
    data['uploaded_on'] = uploadedOn;
    return data;
  }

  static List<UploadHTRModel> listFromJson(List<dynamic> list) {
    List<UploadHTRModel> rows =
        list.map((i) => UploadHTRModel.fromJson(i)).toList();
    return rows;
  }
}
