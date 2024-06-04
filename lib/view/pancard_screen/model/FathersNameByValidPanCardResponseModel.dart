class FathersNameByValidPanCardResponseModel {
  FathersNameByValidPanCardResponseModel({
    this.nameOnPancard,
    this.fathersNameOnPancard,
    this.pan,
    this.name,
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.dob,
    this.aadhaarLinked,
    this.fathersName,
    this.adddress,
    this.requestId,
    this.statusCode,
    this.message,});

  FathersNameByValidPanCardResponseModel.fromJson(dynamic json) {
    nameOnPancard = json['nameOnPancard'];
    fathersNameOnPancard = json['fathersNameOnPancard'];
    pan = json['pan'];
    name = json['name'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    gender = json['gender'];
    dob = json['dob'];
    aadhaarLinked = json['aadhaarLinked'];
    fathersName = json['fathersName'];
    adddress = json['adddress'];
    requestId = json['request_id'];
    statusCode = json['statusCode'];
    message = json['message'];
  }
  String? nameOnPancard;
  dynamic fathersNameOnPancard;
  dynamic pan;
  dynamic name;
  dynamic firstName;
  dynamic middleName;
  dynamic lastName;
  dynamic gender;
  dynamic dob;
  bool? aadhaarLinked;
  dynamic fathersName;
  dynamic adddress;
  dynamic requestId;
  int? statusCode;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nameOnPancard'] = nameOnPancard;
    map['fathersNameOnPancard'] = fathersNameOnPancard;
    map['pan'] = pan;
    map['name'] = name;
    map['firstName'] = firstName;
    map['middleName'] = middleName;
    map['lastName'] = lastName;
    map['gender'] = gender;
    map['dob'] = dob;
    map['aadhaarLinked'] = aadhaarLinked;
    map['fathersName'] = fathersName;
    map['adddress'] = adddress;
    map['request_id'] = requestId;
    map['statusCode'] = statusCode;
    map['message'] = message;
    return map;
  }

}