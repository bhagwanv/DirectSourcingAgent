class PostLeadDsaPersonalDetailReqModel {
  int? leadId;
  int? activityId;
  int? subActivityId;
  String? userId;
  int? companyId;
  int? leadMasterId;
  String? gstRegistrationStatus;
  String? gstNumber;
  String? firmType;
  String? buisnessDocument;
  String? documentId;
  String? companyName;
  String? fullName;
  String? fatherOrHusbandName;
  String? alternatePhoneNo;
  String? emailId;
  String? presentOccupation;
  String? noOfYearsInCurrentEmployment;
  String? qualification;
  String? languagesKnown;
  String? workingWithOther;
  String? referneceName;
  String? referneceContact;
  String? workingLocation;
  String? address;
  String? city;
  String? state;
  String? pincode;
  String? mobileNo;
  String? companyAddress;
  String? companyCity;
  String? companyState;
  String? companyPincode;

  PostLeadDsaPersonalDetailReqModel(
      {this.leadId,
        this.activityId,
        this.subActivityId,
        this.userId,
        this.companyId,
        this.leadMasterId,
        this.gstRegistrationStatus,
        this.gstNumber,
        this.firmType,
        this.buisnessDocument,
        this.documentId,
        this.companyName,
        this.fullName,
        this.fatherOrHusbandName,
        this.alternatePhoneNo,
        this.emailId,
        this.presentOccupation,
        this.noOfYearsInCurrentEmployment,
        this.qualification,
        this.languagesKnown,
        this.workingWithOther,
        this.referneceName,
        this.referneceContact,
        this.workingLocation,
        this.address,
        this.city,
        this.state,
        this.pincode,
        this.mobileNo,
        this.companyAddress,
        this.companyCity,
        this.companyState,
        this.companyPincode});

  PostLeadDsaPersonalDetailReqModel.fromJson(Map<String, dynamic> json) {
    leadId = json['leadId'];
    activityId = json['activityId'];
    subActivityId = json['subActivityId'];
    userId = json['userId'];
    companyId = json['companyId'];
    leadMasterId = json['leadMasterId'];
    gstRegistrationStatus = json['gstRegistrationStatus'];
    gstNumber = json['gstNumber'];
    firmType = json['firmType'];
    buisnessDocument = json['buisnessDocument'];
    documentId = json['documentId'];
    companyName = json['companyName'];
    fullName = json['fullName'];
    fatherOrHusbandName = json['fatherOrHusbandName'];
    alternatePhoneNo = json['alternatePhoneNo'];
    emailId = json['emailId'];
    presentOccupation = json['presentOccupation'];
    noOfYearsInCurrentEmployment = json['noOfYearsInCurrentEmployment'];
    qualification = json['qualification'];
    languagesKnown = json['languagesKnown'];
    workingWithOther = json['workingWithOther'];
    referneceName = json['referneceName'];
    referneceContact = json['referneceContact'];
    workingLocation = json['workingLocation'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    mobileNo = json['mobileNo'];
    companyAddress = json['companyAddress'];
    companyCity = json['companyCity'];
    companyState = json['companyState'];
    companyPincode = json['companyPincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leadId'] = this.leadId;
    data['activityId'] = this.activityId;
    data['subActivityId'] = this.subActivityId;
    data['userId'] = this.userId;
    data['companyId'] = this.companyId;
    data['leadMasterId'] = this.leadMasterId;
    data['gstRegistrationStatus'] = this.gstRegistrationStatus;
    data['gstNumber'] = this.gstNumber;
    data['firmType'] = this.firmType;
    data['buisnessDocument'] = this.buisnessDocument;
    data['documentId'] = this.documentId;
    data['companyName'] = this.companyName;
    data['fullName'] = this.fullName;
    data['fatherOrHusbandName'] = this.fatherOrHusbandName;
    data['alternatePhoneNo'] = this.alternatePhoneNo;
    data['emailId'] = this.emailId;
    data['presentOccupation'] = this.presentOccupation;
    data['noOfYearsInCurrentEmployment'] = this.noOfYearsInCurrentEmployment;
    data['qualification'] = this.qualification;
    data['languagesKnown'] = this.languagesKnown;
    data['workingWithOther'] = this.workingWithOther;
    data['referneceName'] = this.referneceName;
    data['referneceContact'] = this.referneceContact;
    data['workingLocation'] = this.workingLocation;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['mobileNo'] = this.mobileNo;
    data['companyAddress'] = this.companyAddress;
    data['companyCity'] = this.companyCity;
    data['companyState'] = this.companyState;
    data['companyPincode'] = this.companyPincode;
    return data;
  }
}