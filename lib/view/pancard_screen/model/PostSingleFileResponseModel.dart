class PostSingleFileResponseModel {
  PostSingleFileResponseModel({
      this.status, 
      this.message, 
      this.docId, 
      this.filePath,});

  PostSingleFileResponseModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    docId = json['docId'];
    filePath = json['filePath'];
  }
  bool? status;
  String? message;
  int? docId;
  String? filePath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['docId'] = docId;
    map['filePath'] = filePath;
    return map;
  }

}