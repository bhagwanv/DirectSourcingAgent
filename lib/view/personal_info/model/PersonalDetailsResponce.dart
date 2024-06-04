class PersonalDetailsResponce {
  PersonalDetailsResponce({
      this.leadMasterId, 
      this.firstName, 
      this.middleName, 
      this.lastName, 
      this.fatherName, 
      this.fatherLastName, 
      this.gender, 
      this.alternatePhoneNo, 
      this.emailId, 
      this.typeOfAddress, 
      this.resAddress1, 
      this.resAddress2, 
      this.pincode, 
      this.city, 
      this.state, 
      this.permanentAddressLine1, 
      this.permanentAddressLine2, 
      this.permanentPincode, 
      this.permanentCity, 
      this.permanentState, 
      this.residenceStatus, 
      this.modifiedBy, 
      this.modifiedDate, 
      this.status, 
      this.message, 
      this.mobileNo, 
      this.busGSTNO, 
      this.ownershipType, 
      this.marital, 
      this.ownershipTypeProof, 
      this.electricityBillDocumentId, 
      this.ivrsNumber, 
      this.ownershipTypeName, 
      this.ownershipTypeAddress, 
      this.ownershipTypeResponseId, 
      this.manulaElectrictyBillImage,
      this.electricityServiceProvider,
      this.electricityState,

  });

  PersonalDetailsResponce.fromJson(dynamic json) {
    leadMasterId = json['leadMasterId'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    fatherName = json['fatherName'];
    fatherLastName = json['fatherLastName'];
    gender = json['gender'];
    alternatePhoneNo = json['alternatePhoneNo'];
    emailId = json['emailId'];
    typeOfAddress = json['typeOfAddress'];
    resAddress1 = json['resAddress1'];
    resAddress2 = json['resAddress2'];
    pincode = json['pincode'];
    city = json['city'];
    state = json['state'];
    permanentAddressLine1 = json['permanentAddressLine1'];
    permanentAddressLine2 = json['permanentAddressLine2'];
    permanentPincode = json['permanentPincode'];
    permanentCity = json['permanentCity'];
    permanentState = json['permanentState'];
    residenceStatus = json['residenceStatus'];
    modifiedBy = json['modifiedBy'];
    modifiedDate = json['modifiedDate'];
    status = json['status'];
    message = json['message'];
    mobileNo = json['mobileNo'];
    busGSTNO = json['busGSTNO'];
    ownershipType = json['ownershipType'];
    marital = json['marital'];
    ownershipTypeProof = json['ownershipTypeProof'];
    electricityBillDocumentId = json['electricityBillDocumentId'];
    ivrsNumber = json['ivrsNumber'];
    ownershipTypeName = json['ownershipTypeName'];
    ownershipTypeAddress = json['ownershipTypeAddress'];
    ownershipTypeResponseId = json['ownershipTypeResponseId'];
    manulaElectrictyBillImage = json['manulaElectrictyBillImage'];
    electricityServiceProvider = json['electricityServiceProvider'];
    electricityState = json['electricityState'];
  }
  int? leadMasterId;
  String? firstName;
  String? middleName= "";
  String? lastName;
  String? fatherName;
  String? fatherLastName;
  String? gender;
  String? alternatePhoneNo;
  String? emailId;
  dynamic typeOfAddress;
  String? resAddress1;
  String? resAddress2;
  int? pincode;
  int? city;
  int? state;
  String? permanentAddressLine1;
  String? permanentAddressLine2;
  int? permanentPincode;
  int? permanentCity;
  int? permanentState;
  dynamic residenceStatus;
  dynamic modifiedBy;
  dynamic modifiedDate;
  bool? status;
  dynamic message;
  String? mobileNo;
  String? busGSTNO;
  String? ownershipType;
  String? marital;
  String? ownershipTypeProof;
  int? electricityBillDocumentId;
  dynamic ivrsNumber;
  dynamic ownershipTypeName;
  dynamic ownershipTypeAddress;
  dynamic ownershipTypeResponseId;
  String? manulaElectrictyBillImage;
  String? electricityServiceProvider;
  String? electricityState;



  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['leadMasterId'] = leadMasterId;
    map['firstName'] = firstName;
    map['middleName'] = middleName;
    map['lastName'] = lastName;
    map['fatherName'] = fatherName;
    map['fatherLastName'] = fatherLastName;
    map['gender'] = gender;
    map['alternatePhoneNo'] = alternatePhoneNo;
    map['emailId'] = emailId;
    map['typeOfAddress'] = typeOfAddress;
    map['resAddress1'] = resAddress1;
    map['resAddress2'] = resAddress2;
    map['pincode'] = pincode;
    map['city'] = city;
    map['state'] = state;
    map['permanentAddressLine1'] = permanentAddressLine1;
    map['permanentAddressLine2'] = permanentAddressLine2;
    map['permanentPincode'] = permanentPincode;
    map['permanentCity'] = permanentCity;
    map['permanentState'] = permanentState;
    map['residenceStatus'] = residenceStatus;
    map['modifiedBy'] = modifiedBy;
    map['modifiedDate'] = modifiedDate;
    map['status'] = status;
    map['message'] = message;
    map['mobileNo'] = mobileNo;
    map['busGSTNO'] = busGSTNO;
    map['ownershipType'] = ownershipType;
    map['marital'] = marital;
    map['ownershipTypeProof'] = ownershipTypeProof;
    map['electricityBillDocumentId'] = electricityBillDocumentId;
    map['ivrsNumber'] = ivrsNumber;
    map['ownershipTypeName'] = ownershipTypeName;
    map['ownershipTypeAddress'] = ownershipTypeAddress;
    map['ownershipTypeResponseId'] = ownershipTypeResponseId;
    map['manulaElectrictyBillImage'] = manulaElectrictyBillImage;
    map['electricityServiceProvider'] = electricityServiceProvider;
    map['electricityState'] = electricityState;
    return map;
  }

}