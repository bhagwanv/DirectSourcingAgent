class AadhaarGenerateOTPRequestModel {

  String? DocumentNumber;
  String? FrontFileUrl;
  String? BackFileUrl;
  String? FrontDocumentId;
  String? BackDocumentId;
  String? otp;
  String? requestId;


  AadhaarGenerateOTPRequestModel({
    this.DocumentNumber,
    this.FrontFileUrl,
    this.BackFileUrl,
    this.FrontDocumentId,
    this.BackDocumentId,
    this.otp,
    this.requestId,});

  AadhaarGenerateOTPRequestModel.fromJson(dynamic json) {
    DocumentNumber = json['DocumentNumber'];
    FrontFileUrl = json['FrontFileUrl'];
    BackFileUrl = json['BackFileUrl'];
    FrontDocumentId = json['FrontDocumentId'];
    BackDocumentId = json['BackDocumentId'];
    otp = json['otp'];
    requestId = json['requestId'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DocumentNumber'] = DocumentNumber;
    map['FrontFileUrl'] = FrontFileUrl;
    map['BackFileUrl'] = BackFileUrl;
    map['FrontDocumentId'] = FrontDocumentId;
    map['BackDocumentId'] = BackDocumentId;
    map['otp'] = otp;
    map['requestId'] = requestId;
    return map;
  }

}