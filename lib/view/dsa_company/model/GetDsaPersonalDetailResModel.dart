class GetDsaPersonalDetailResModel {
  String? gstStatus;
  Null? gstNumber;
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
  String? cityId;
  String? stateId;
  String? companyAddress;
  String? companyPinCode;
  String? companyCity;
  String? companyState;
  String? buisnessDocImg;
  String? companyCityId;
  String? companyStateId;

  GetDsaPersonalDetailResModel(
      {this.gstStatus,
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
        this.stateId,
        this.companyAddress,
        this.companyPinCode,
        this.companyCity,
        this.companyState,
        this.buisnessDocImg,
        this.companyCityId,
        this.companyStateId});

  GetDsaPersonalDetailResModel.fromJson(Map<String, dynamic> json) {
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
    workingLocation = json['workingLocation'];
    cityId = json['cityId'];
    stateId = json['stateId'];
    companyAddress = json['companyAddress'];
    companyPinCode = json['companyPinCode'];
    companyCity = json['companyCity'];
    companyState = json['companyState'];
    buisnessDocImg = json['buisnessDocImg'];
    companyCityId = json['companyCityId'];
    companyStateId = json['companyStateId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gstStatus'] = this.gstStatus;
    data['gstNumber'] = this.gstNumber;
    data['firmType'] = this.firmType;
    data['buisnessDocument'] = this.buisnessDocument;
    data['documentId'] = this.documentId;
    data['companyName'] = this.companyName;
    data['fullName'] = this.fullName;
    data['fatherOrHusbandName'] = this.fatherOrHusbandName;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['address'] = this.address;
    data['pinCode'] = this.pinCode;
    data['city'] = this.city;
    data['state'] = this.state;
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
    data['cityId'] = this.cityId;
    data['stateId'] = this.stateId;
    data['companyAddress'] = this.companyAddress;
    data['companyPinCode'] = this.companyPinCode;
    data['companyCity'] = this.companyCity;
    data['companyState'] = this.companyState;
    data['buisnessDocImg'] = this.buisnessDocImg;
    data['companyCityId'] = this.companyCityId;
    data['companyStateId'] = this.companyStateId;
    return data;
  }
}
