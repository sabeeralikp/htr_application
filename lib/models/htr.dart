///
/// [First commit]
///
/// [author] Sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	(March 1st, 2023 1:14 PM) 
///
////// The `HTRModel` class represents Handwriting Text Recognition (HTR) data in the Flutter application.
///
/// This class is used to model HTR data received from a Django backend API.
///
/// Attributes:
///   - [id]: An integer representing the unique identifier for the HTR data.
///   - [filename]: A string containing the filename of the HTR data.
///   - [file]: A string representing the file path or URL for the HTR data.
///   - [extractedText]: A string containing the text extracted from the handwriting.
///   - [thresholdValue]: An integer representing the threshold value used in the recognition process.
///   - [dilateXValue]: An integer representing the dilation value in the X-axis during processing.
///   - [dilateYValue]: An integer representing the dilation value in the Y-axis during processing.
///   - [uploadedBy]: A string containing the name of the user who uploaded the HTR data.
///   - [uploadedOn]: A DateTime object representing the date and time when the HTR data was uploaded.
///
/// Constructors:
///   - [HTRModel]: Initializes an `HTRModel` object with optional parameters.
///       - [id]: The unique identifier.
///       - [filename]: The filename.
///       - [file]: The file path or URL.
///       - [uploadedBy]: The name of the user who uploaded the data.
///
///   - [HTRModel.fromJson]: Creates an `HTRModel` object from a JSON map.
///
///   - [toJson]: Converts the `HTRModel` object to a JSON map.
///
///   - [listFromJson]: Creates a list of `HTRModel` objects from a JSON list.
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

/// Constructs an `HTRModel` object with optional parameters.
  HTRModel({this.id, this.filename, this.file, this.uploadedBy});
/// Creates an `HTRModel` object from a JSON map.
///
/// [json]: A map containing JSON data to initialize the object.
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
/// Converts the `HTRModel` object to a JSON map.
///
/// Returns: A map representing the object in JSON format.
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
/// Creates a list of `HTRModel` objects from a JSON list.
///
/// [list]: A list containing JSON data to initialize the objects.
///
/// Returns: A list of `HTRModel` objects.
  static List<HTRModel> listFromJson(List<dynamic> list) {
    List<HTRModel> rows = list.map((i) => HTRModel.fromJson(i)).toList();
    return rows;
  }
}
