/// 
/// [Changes in Segment page]
///
/// [author] Sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	(March 21st, 2023 3:02 PM) 
///
/// The `UploadHTRModel` class represents data related to the upload of Handwriting Text Recognition (HTR) files
/// in the Flutter application.
///
/// This class is used to model data for uploaded HTR files, including file details such as filename, file type,
/// number of pages, uploader information, and timestamps. It is typically used with a Django backend API.
///
/// Attributes:
///   - [id]: An integer representing the unique identifier for the uploaded HTR data.
///   - [filename]: A string containing the filename of the uploaded HTR file.
///   - [file]: A string representing the file path or URL of the uploaded HTR file.
///   - [fileType]: A string indicating the type or format of the uploaded HTR file.
///   - [numberOfPages]: An integer representing the number of pages in the uploaded HTR document.
///   - [uploadedBy]: A string containing the name or identifier of the user who uploaded the HTR file.
///   - [uploadedOn]: A string representing the date and time when the HTR file was uploaded.
///   - [segment]: A string that may indicate a specific segment or category for the uploaded HTR data.
///
/// Constructors:
///   - [UploadHTRModel]: Initializes an `UploadHTRModel` object with optional parameters.
///       - [id]: The unique identifier for the uploaded HTR data.
///       - [filename]: The filename of the uploaded HTR file.
///       - [file]: The file path or URL of the uploaded HTR file.
///       - [fileType]: The type or format of the uploaded HTR file.
///       - [numberOfPages]: The number of pages in the uploaded HTR document.
///       - [uploadedBy]: The name or identifier of the user who uploaded the HTR file.
///       - [uploadedOn]: The timestamp indicating when the HTR file was uploaded.
///
///   - [UploadHTRModel.fromJson]: Creates an `UploadHTRModel` object from a JSON map.
///
///   - [toJson]: Converts the `UploadHTRModel` object to a JSON map.
///
///   - [listFromJson]: Creates a list of `UploadHTRModel` objects from a JSON list.
class UploadHTRModel {
  int? id;
  String? filename;
  String? file;
  String? fileType;
  int? numberOfPages;
  String? uploadedBy;
  String? uploadedOn;
  String? segment;

/// Constructs an `UploadHTRModel` object with optional parameters.

  UploadHTRModel(
      {this.id,
      this.filename,
      this.file,
      this.fileType,
      this.numberOfPages,
      this.uploadedBy,
      this.uploadedOn});
/// Creates an `UploadHTRModel` object from a JSON map.
///
/// [json]: A map containing JSON data to initialize the object.      

  UploadHTRModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    filename = json['filename'];
    file = json['file'];
    fileType = json['file_type'];
    numberOfPages = json['number_of_pages'];
    uploadedBy = json['uploaded_by'];
    uploadedOn = json['uploaded_on'];
  }
/// Converts the `UploadHTRModel` object to a JSON map.
///
/// Returns: A map representing the object in JSON format.  

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

/// Creates a list of `UploadHTRModel` objects from a JSON list.
///
/// [list]: A list containing JSON data to initialize the objects.
///
/// Returns: A list of `UploadHTRModel` objects.
  static List<UploadHTRModel> listFromJson(List<dynamic> list) {
    List<UploadHTRModel> rows =
        list.map((i) => UploadHTRModel.fromJson(i)).toList();
    return rows;
  }
}
