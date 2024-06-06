class ConnectorInfoReqModel {
  int? leadId;
  int? activityId;
  int? subActivityId;
  String? userId;
  int? companyId;
  int? leadMasterId;
  String? fullName;
  String? fatherName;
  String? alternatePhoneNo;
  String? emailId;
  String? presentEmployment;
  String? languagesKnown;
  String? workingWithOther;
  String? referenceName;
  String? referneceContact;
  String? WorkingLocation;
  int? currentAddressId;
  String? mobileNo;
  String? City;
  String? State;
  String? Pincode;
  String? Address;

  ConnectorInfoReqModel(
      {this.leadId,
        this.activityId,
        this.subActivityId,
        this.userId,
        this.companyId,
        this.leadMasterId,
        this.fullName,
        this.fatherName,
        this.alternatePhoneNo,
        this.emailId,
        this.presentEmployment,
        this.languagesKnown,
        this.workingWithOther,
        this.referenceName,
        this.referneceContact,
        this.WorkingLocation,
        this.currentAddressId,
        this.mobileNo,
        this.City,
        this.State,
        this.Pincode,
      this.Address});

  ConnectorInfoReqModel.fromJson(Map<String, dynamic> json) {
    leadId = json['leadId'];
    activityId = json['activityId'];
    subActivityId = json['subActivityId'];
    userId = json['userId'];
    companyId = json['companyId'];
    leadMasterId = json['leadMasterId'];
    fullName = json['fullName'];
    fatherName = json['fatherName'];
    alternatePhoneNo = json['alternatePhoneNo'];
    emailId = json['emailId'];
    presentEmployment = json['presentEmployment'];
    languagesKnown = json['languagesKnown'];
    workingWithOther = json['workingWithOther'];
    referenceName = json['referenceName'];
    referneceContact = json['referneceContact'];
    WorkingLocation = json['WorkingLocation'];
    currentAddressId = json['currentAddressId'];
    mobileNo = json['mobileNo'];
    City = json['City'];
    State = json['State'];
    Pincode = json['Pincode'];
    Address = json['Address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leadId'] = this.leadId;
    data['activityId'] = this.activityId;
    data['subActivityId'] = this.subActivityId;
    data['userId'] = this.userId;
    data['companyId'] = this.companyId;
    data['leadMasterId'] = this.leadMasterId;
    data['fullName'] = this.fullName;
    data['fatherName'] = this.fatherName;
    data['alternatePhoneNo'] = this.alternatePhoneNo;
    data['emailId'] = this.emailId;
    data['presentEmployment'] = this.presentEmployment;
    data['languagesKnown'] = this.languagesKnown;
    data['workingWithOther'] = this.workingWithOther;
    data['referenceName'] = this.referenceName;
    data['referneceContact'] = this.referneceContact;
    data['WorkingLocation'] = this.WorkingLocation;
    data['currentAddressId'] = this.currentAddressId;
    data['mobileNo'] = this.mobileNo;
    data['City'] = this.City;
    data['State'] = this.State;
    data['Pincode'] = this.Pincode;
    data['Address'] = this.Address;
    return data;
  }
}