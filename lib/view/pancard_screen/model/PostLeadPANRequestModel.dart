class PostLeadPanRequestModel {
  PostLeadPanRequestModel({
      this.leadId, 
      this.userId, 
      this.activityId, 
      this.subActivityId, 
      this.uniqueId, 
      this.imagePath, 
      this.documentId, 
      this.companyId, 
      this.fathersName, 
      this.dob, 
      this.name,});

  PostLeadPanRequestModel.fromJson(dynamic json) {
    leadId = json['leadId'];
    userId = json['UserId'];
    activityId = json['ActivityId'];
    subActivityId = json['SubActivityId'];
    uniqueId = json['UniqueId'];
    imagePath = json['ImagePath'];
    documentId = json['DocumentId'];
    companyId = json['CompanyId'];
    fathersName = json['FathersName'];
    dob = json['DOB'];
    name = json['Name'];
  }
  int? leadId;
  String? userId;
  int? activityId;
  int? subActivityId;
  String? uniqueId;
  String? imagePath;
  int? documentId;
  int? companyId;
  String? fathersName;
  String? dob;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['leadId'] = leadId;
    map['UserId'] = userId;
    map['ActivityId'] = activityId;
    map['SubActivityId'] = subActivityId;
    map['UniqueId'] = uniqueId;
    map['ImagePath'] = imagePath;
    map['DocumentId'] = documentId;
    map['CompanyId'] = companyId;
    map['FathersName'] = fathersName;
    map['DOB'] = dob;
    map['Name'] = name;
    return map;
  }

}