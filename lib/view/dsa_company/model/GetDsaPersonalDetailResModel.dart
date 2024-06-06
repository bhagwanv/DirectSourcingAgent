class GetDsaPersonalDetailResModel {

  String? gstStatus;
  String? gstNumber;
  String? firmType;
  String? buisnessDocument;
  String? documentId;
  String? companyName;
  String? fullName;
  String? fatherOrHusbandName;
  String? dob;
  int? age;
  String? address;
  String? pinCode;
  String? city;
  String? state;
  dynamic alternatePhoneNo;
  dynamic emailId;
  dynamic presentOccupation;
  dynamic noOfYearsInCurrentEmployment;
  dynamic qualification;
  dynamic languagesKnown;
  dynamic workingWithOther;
  dynamic referneceName;
  dynamic referneceContact;
  dynamic workingLocation;
  String? cityId;
  String? stateId;

  GetDsaPersonalDetailResModel({
      this.gstStatus, 
      this.gstNumber, 
      this.firmType, 
      this.buisnessDocument, 
      this.documentId, 
      this.companyName, 
      this.fullName, 
      this.fatherOrHusbandName, 
      this.dob, 
      this.age, 
      this.address, 
      this.pinCode, 
      this.city, 
      this.state, 
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
      this.cityId, 
      this.stateId,});

  GetDsaPersonalDetailResModel.fromJson(dynamic json) {
    gstStatus = json['gstStatus'];
    gstNumber = json['gstNumber'];
    firmType = json['firmType'];
    buisnessDocument = json['buisnessDocument'];
    documentId = json['documentId'];
    companyName = json['companyName'];
    fullName = json['fullName'];
    fatherOrHusbandName = json['fatherOrHusbandName'];
    dob = json['dob'];
    age = json['age'];
    address = json['address'];
    pinCode = json['pinCode'];
    city = json['city'];
    state = json['state'];
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
    cityId = json['cityId'];
    stateId = json['stateId'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['gstStatus'] = gstStatus;
    map['gstNumber'] = gstNumber;
    map['firmType'] = firmType;
    map['buisnessDocument'] = buisnessDocument;
    map['documentId'] = documentId;
    map['companyName'] = companyName;
    map['fullName'] = fullName;
    map['fatherOrHusbandName'] = fatherOrHusbandName;
    map['dob'] = dob;
    map['age'] = age;
    map['address'] = address;
    map['pinCode'] = pinCode;
    map['city'] = city;
    map['state'] = state;
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
    map['cityId'] = cityId;
    map['stateId'] = stateId;
    return map;
  }

}