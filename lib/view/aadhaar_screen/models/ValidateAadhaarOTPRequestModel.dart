class ValidateAadhaarOTPRequestModel {
  int? leadId;
  String? userId;
  int? activityId;
  int? subActivityId;
  String? documentNumber;
  String? frontFileUrl;
  String? backFileUrl;
  String? frontDocumentId;
  String? backDocumentId;
  String? otp;
  String? requestId;
  int? companyId;

  ValidateAadhaarOTPRequestModel(
      {this.leadId,
      this.userId,
      this.activityId,
      this.subActivityId,
      this.documentNumber,
      this.frontFileUrl,
      this.backFileUrl,
      this.frontDocumentId,
      this.backDocumentId,
      this.otp,
      this.requestId,
      this.companyId});

  ValidateAadhaarOTPRequestModel.fromJson(Map<String, dynamic> json) {
    leadId = json['LeadId'];
    userId = json['UserId'];
    activityId = json['ActivityId'];
    subActivityId = json['SubActivityId'];
    documentNumber = json['DocumentNumber'];
    frontFileUrl = json['FrontFileUrl'];
    backFileUrl = json['BackFileUrl'];
    frontDocumentId = json['FrontDocumentId'];
    backDocumentId = json['BackDocumentId'];
    otp = json['otp'];
    requestId = json['requestId'];
    companyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LeadId'] = this.leadId;
    data['UserId'] = this.userId;
    data['ActivityId'] = this.activityId;
    data['SubActivityId'] = this.subActivityId;
    data['DocumentNumber'] = this.documentNumber;
    data['FrontFileUrl'] = this.frontFileUrl;
    data['BackFileUrl'] = this.backFileUrl;
    data['FrontDocumentId'] = this.frontDocumentId;
    data['BackDocumentId'] = this.backDocumentId;
    data['otp'] = this.otp;
    data['requestId'] = this.requestId;
    data['CompanyId'] = this.companyId;
    return data;
  }
}
