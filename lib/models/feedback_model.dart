///
/// [Feedback Added]
///
/// [author] Sabeerali
/// [since]	v0.0.1
/// [version]	v1.0.0	(July 12th, 2023 4:18 PM) 
///
////// The `FeedbackModel` class represents feedback data in the Flutter application.
///
/// This class is used to model feedback data received from a Django backend API.
///
/// Attributes:
///   - [uploadHtr]: An integer representing the upload HTR (Handwriting Text Recognition).
///   - [raiting]: A double representing the rating given for the feedback.
///   - [remarks]: A string containing remarks or comments provided with the feedback.
///   - [createdOn]: A string representing the date and time when the feedback was created.
///   - [createdBy]: A dynamic value representing the creator or author of the feedback.
///
/// Constructors:
///   - [FeedbackModel]: Initializes a `FeedbackModel` object with optional parameters.
///       - [uploadHtr]: The upload HTR value.
///       - [raiting]: The rating value.
///       - [remarks]: The remarks or comments.
///       - [createdOn]: The creation timestamp.
///       - [createdBy]: The creator information.
///
///   - [FeedbackModel.fromJson]: Creates a `FeedbackModel` object from a JSON map.
///
///   - [toJson]: Converts the `FeedbackModel` object to a JSON map.
class FeedbackModel {
  int? uploadHtr;
  double? raiting;
  String? remarks;
  String? createdOn;
  dynamic createdBy;
/// Constructs a `FeedbackModel` object with optional parameters.
  FeedbackModel({this.uploadHtr, this.raiting, this.remarks, this.createdOn, this.createdBy});
/// Creates a `FeedbackModel` object from a JSON map.
///
/// [json]: A map containing JSON data to initialize the object.
  FeedbackModel.fromJson(Map<String, dynamic> json) {
    uploadHtr = json["upload_htr"];
    raiting = json["raiting"];
    remarks = json["remarks"];
    createdOn = json["created_on"];
    createdBy = json["created_by"];
  }
/// Converts the `FeedbackModel` object to a JSON map.
///
/// Returns: A map representing the object in JSON format.
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