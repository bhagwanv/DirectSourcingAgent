class LeadSelfieResponseModel {
  LeadSelfieResponseModel({
      this.frontImageUrl, 
      this.frontDocumentId, 
      this.status, 
      this.message,});

  LeadSelfieResponseModel.fromJson(dynamic json) {
    frontImageUrl = json['frontImageUrl'];
    frontDocumentId = json['frontDocumentId'];
    status = json['status'];
    message = json['message'];
  }
  String? frontImageUrl;
  int? frontDocumentId;
  bool? status;
  dynamic message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['frontImageUrl'] = frontImageUrl;
    map['frontDocumentId'] = frontDocumentId;
    map['status'] = status;
    map['message'] = message;
    return map;
  }

}