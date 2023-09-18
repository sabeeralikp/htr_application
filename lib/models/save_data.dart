/// 
/// [Auto save Added]
///
/// [author] Sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	(April 5th, 2023 11:44 AM) 
///
/// The `SaveDataModel` class represents data for saving annotations in the Flutter application.
///
/// This class is used to model data for saving annotations, including image coordinates
/// and annotated text, typically for use with a Django backend API.
///
/// Attributes:
///   - [imageCordinate]: An integer representing the image coordinate associated with the annotation.
///   - [annotatedText]: A string containing the annotated text associated with the annotation.
///
/// Constructors:
///   - [SaveDataModel]: Initializes a `SaveDataModel` object with optional parameters.
///       - [imageCordinate]: The image coordinate for the annotation.
///       - [annotatedText]: The text annotation.
///
///   - [SaveDataModel.fromJson]: Creates a `SaveDataModel` object from a JSON map.
///
///   - [toJson]: Converts the `SaveDataModel` object to a JSON map.
///
///   - [listFromJson]: Creates a list of `SaveDataModel` objects from a JSON list.
class SaveDataModel {
  int? imageCordinate;
  String? annotatedText;
  
/// Constructs a `SaveDataModel` object with optional parameters.
  SaveDataModel({this.imageCordinate, this.annotatedText});
/// Creates a `SaveDataModel` object from a JSON map.
///
/// [json]: A map containing JSON data to initialize the object.
  SaveDataModel.fromJson(Map<String, dynamic> json) {
    imageCordinate = json['image_cordinate'].toInt();
    annotatedText = json['annotated_text'].toString();
  }
/// Converts the `SaveDataModel` object to a JSON map.
///
/// Returns: A map representing the object in JSON format.  
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image_cordinate'] = imageCordinate;
    data['annotated_text'] = annotatedText;
    return data;
  }
/// Creates a list of `SaveDataModel` objects from a JSON list.
///
/// [list]: A list containing JSON data to initialize the objects.
///
/// Returns: A list of `SaveDataModel` objects.
  static List<SaveDataModel> listFromJson(List<dynamic> list) {
    List<SaveDataModel> rows =
        list.map((i) => SaveDataModel.fromJson(i)).toList();
    return rows;
  }
}
