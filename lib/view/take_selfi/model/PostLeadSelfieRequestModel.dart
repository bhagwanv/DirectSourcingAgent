class PostLeadSelfieRequestModel {
  PostLeadSelfieRequestModel({
      this.leadId, 
      this.userId, 
      this.activityId, 
      this.subActivityId, 
      this.frontImageUrl, 
      this.frontDocumentId, 
      this.companyId,});

  PostLeadSelfieRequestModel.fromJson(dynamic json) {
    leadId = json['LeadId'];
    userId = json['UserId'];
    activityId = json['ActivityId'];
    subActivityId = json['SubActivityId'];
    frontImageUrl = json['FrontImageUrl'];
    frontDocumentId = json['FrontDocumentId'];
    companyId = json['CompanyId'];
  }
  int? leadId;
  String? userId;
  int? activityId;
  int? subActivityId;
  String? frontImageUrl;
  int? frontDocumentId;
  int? companyId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['LeadId'] = leadId;
    map['UserId'] = userId;
    map['ActivityId'] = activityId;
    map['SubActivityId'] = subActivityId;
    map['FrontImageUrl'] = frontImageUrl;
    map['FrontDocumentId'] = frontDocumentId;
    map['CompanyId'] = companyId;
    return map;
  }

}