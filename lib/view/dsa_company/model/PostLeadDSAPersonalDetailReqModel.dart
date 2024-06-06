class PostLeadDsaPersonalDetailReqModel {
  PostLeadDsaPersonalDetailReqModel({
      this.leadId, 
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
      this.currentAddressId, 
      this.mobileNo,
      this.address ,
      this.city ,
      this.state ,
      this.pincode ,

  });

  PostLeadDsaPersonalDetailReqModel.fromJson(dynamic json) {
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
    workingLocation = json['WorkingLocation'];
    currentAddressId = json['currentAddressId'];
    mobileNo = json['mobileNo'];
    address = json['Address'];
    city = json['City'];
    state = json['State'];
    pincode = json['Pincode'];
  }
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
  int? currentAddressId;
  String? mobileNo;
  String? address;
  String? city;
  String? state;
  String? pincode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['leadId'] = leadId;
    map['activityId'] = activityId;
    map['subActivityId'] = subActivityId;
    map['userId'] = userId;
    map['companyId'] = companyId;
    map['leadMasterId'] = leadMasterId;
    map['gstRegistrationStatus'] = gstRegistrationStatus;
    map['gstNumber'] = gstNumber;
    map['firmType'] = firmType;
    map['buisnessDocument'] = buisnessDocument;
    map['documentId'] = documentId;
    map['companyName'] = companyName;
    map['fullName'] = fullName;
    map['fatherOrHusbandName'] = fatherOrHusbandName;
    map['alternatePhoneNo'] = alternatePhoneNo;
    map['emailId'] = emailId;
    map['presentOccupation'] = presentOccupation;
    map['noOfYearsInCurrentEmployment'] = noOfYearsInCurrentEmployment;
    map['qualification'] = qualification;
    map['languagesKnown'] = languagesKnown;
    map['workingWithOther'] = workingWithOther;
    map['referneceName'] = referneceName;
    map['referneceContact'] = referneceContact;
    map['WorkingLocation'] = workingLocation;
    map['currentAddressId'] = currentAddressId;
    map['mobileNo'] = mobileNo;
    map['Address'] = address;
    map['City'] = city;
    map['State'] = state;
    map['Pincode'] = pincode;
    return map;
  }

}