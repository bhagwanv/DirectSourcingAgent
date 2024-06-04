class PersonalDetailsRequestModel {
  String? firstName;
  String? lastName;
  String? fatherName;
  String? fatherLastName;
  String? dOB;
  String? gender;
  String? marital;
  String? alternatePhoneNo;
  String? emailId;
  String? typeOfAddress;
  String? permanentAddressLine1;
  String? permanentAddressLine2;
  String? permanentPincode;
  String? permanentCity;
  String? permanentState;
  String? resAddress1;
  String? resAddress2;
  String? pincode;
  String? city;
  String? state;
  String? residenceStatus;
  int? leadId;
  String? userId;
  int? activityId;
  int? subActivityId;
  String? middleName;
  int? companyId;
  String? mobileNo;
  String? ownershipType;
  String? ownershipTypeAddress;
  String? ownershipTypeProof;
  int? electricityBillDocumentId;
  String? ownershipTypeName;
  String? ownershipTypeResponseId;
  String? ivrsNumber;
  String? electricityServiceProvider;
  String? electricityState;

  PersonalDetailsRequestModel(
      {this.firstName,
        this.lastName,
        this.fatherName,
        this.fatherLastName,
        this.dOB,
        this.gender,
        this.marital,
        this.alternatePhoneNo,
        this.emailId,
        this.typeOfAddress,
        this.permanentAddressLine1,
        this.permanentAddressLine2,
        this.permanentPincode,
        this.permanentCity,
        this.permanentState,
        this.resAddress1,
        this.resAddress2,
        this.pincode,
        this.city,
        this.state,
        this.residenceStatus,
        this.leadId,
        this.userId,
        this.activityId,
        this.subActivityId,
        this.middleName,
        this.companyId,
        this.mobileNo,
        this.ownershipType,
        this.ownershipTypeAddress,
        this.ownershipTypeProof,
        this.electricityBillDocumentId,
        this.ownershipTypeName,
        this.ownershipTypeResponseId,
        this.ivrsNumber,
        this.electricityServiceProvider,
        this.electricityState

      });

  PersonalDetailsRequestModel.fromJson(Map<String, dynamic> json) {
    firstName = json['FirstName'];
    lastName = json['LastName'];
    fatherName = json['FatherName'];
    fatherLastName = json['FatherLastName'];
    dOB = json['DOB'];
    gender = json['Gender'];
    marital = json['Marital'];
    alternatePhoneNo = json['AlternatePhoneNo'];
    emailId = json['EmailId'];
    typeOfAddress = json['TypeOfAddress'];
    permanentAddressLine1 = json['PermanentAddressLine1'];
    permanentAddressLine2 = json['PermanentAddressLine2'];
    permanentPincode = json['PermanentPincode'];
    permanentCity = json['PermanentCity'];
    permanentState = json['PermanentState'];
    resAddress1 = json['ResAddress1'];
    resAddress2 = json['ResAddress2'];
    pincode = json['Pincode'];
    city = json['City'];
    state = json['State'];
    residenceStatus = json['ResidenceStatus'];
    leadId = json['LeadId'];
    userId = json['UserId'];
    activityId = json['ActivityId'];
    subActivityId = json['SubActivityId'];
    middleName = json['MiddleName'];
    companyId = json['CompanyId'];
    mobileNo = json['MobileNo'];
    ownershipType = json['OwnershipType'];
    ownershipTypeAddress = json['OwnershipTypeAddress'];
    ownershipTypeProof = json['OwnershipTypeProof'];
    electricityBillDocumentId = json['ElectricityBillDocumentId'];
    ownershipTypeName = json['OwnershipTypeName'];
    ownershipTypeResponseId = json['OwnershipTypeResponseId'];
    ivrsNumber = json['ivrsNumber'];
    electricityServiceProvider = json['electricityServiceProvider'];
    electricityState = json['electricityState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['FatherName'] = this.fatherName;
    data['FatherLastName'] = this.fatherLastName;
    data['DOB'] = this.dOB;
    data['Gender'] = this.gender;
    data['Marital'] = this.marital;
    data['AlternatePhoneNo'] = this.alternatePhoneNo;
    data['EmailId'] = this.emailId;
    data['TypeOfAddress'] = this.typeOfAddress;
    data['PermanentAddressLine1'] = this.permanentAddressLine1;
    data['PermanentAddressLine2'] = this.permanentAddressLine2;
    data['PermanentPincode'] = this.permanentPincode;
    data['PermanentCity'] = this.permanentCity;
    data['PermanentState'] = this.permanentState;
    data['ResAddress1'] = this.resAddress1;
    data['ResAddress2'] = this.resAddress2;
    data['Pincode'] = this.pincode;
    data['City'] = this.city;
    data['State'] = this.state;
    data['ResidenceStatus'] = this.residenceStatus;
    data['LeadId'] = this.leadId;
    data['UserId'] = this.userId;
    data['ActivityId'] = this.activityId;
    data['SubActivityId'] = this.subActivityId;
    data['MiddleName'] = this.middleName;
    data['CompanyId'] = this.companyId;
    data['MobileNo'] = this.mobileNo;
    data['OwnershipType'] = this.ownershipType;
    data['OwnershipTypeAddress'] = this.ownershipTypeAddress;
    data['OwnershipTypeProof'] = this.ownershipTypeProof;
    data['ElectricityBillDocumentId'] = this.electricityBillDocumentId;
    data['OwnershipTypeName'] = this.ownershipTypeName;
    data['OwnershipTypeResponseId'] = this.ownershipTypeResponseId;
    data['ivrsNumber'] = this.ivrsNumber;
    data['electricityServiceProvider'] = this.electricityServiceProvider;
    data['electricityState'] = this.electricityState;
    return data;
  }
}
