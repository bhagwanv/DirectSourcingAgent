class ConnectorInfoResponce {
  String? fullName;
  String? fatherName;
  String? dob;
  int? age;
  String? address;
  String? alternatePhoneNo;
  String? emailId;
  String? presentEmployment;
  String? languagesKnown;
  String? workingWithOther;
  String? referenceName;
  String? referneceContact;
  String? referneceLocation;
  int? pincode;
  int? cityId;
  int? stateId;
  String? city;
  String? state;

  ConnectorInfoResponce(
      {this.fullName,
        this.fatherName,
        this.dob,
        this.age,
        this.address,
        this.alternatePhoneNo,
        this.emailId,
        this.presentEmployment,
        this.languagesKnown,
        this.workingWithOther,
        this.referenceName,
        this.referneceContact,
        this.referneceLocation,
        this.pincode,
        this.cityId,
        this.stateId,
        this.city,
        this.state});

  ConnectorInfoResponce.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    fatherName = json['fatherName'];
    dob = json['dob'];
    age = json['age'];
    address = json['address'];
    alternatePhoneNo = json['alternatePhoneNo'];
    emailId = json['emailId'];
    presentEmployment = json['presentEmployment'];
    languagesKnown = json['languagesKnown'];
    workingWithOther = json['workingWithOther'];
    referenceName = json['referenceName'];
    referneceContact = json['referneceContact'];
    referneceLocation = json['referneceLocation'];
    pincode = json['pincode'];
    cityId = json['cityId'];
    stateId = json['stateId'];
    city = json['city'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['fatherName'] = this.fatherName;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['address'] = this.address;
    data['alternatePhoneNo'] = this.alternatePhoneNo;
    data['emailId'] = this.emailId;
    data['presentEmployment'] = this.presentEmployment;
    data['languagesKnown'] = this.languagesKnown;
    data['workingWithOther'] = this.workingWithOther;
    data['referenceName'] = this.referenceName;
    data['referneceContact'] = this.referneceContact;
    data['referneceLocation'] = this.referneceLocation;
    data['pincode'] = this.pincode;
    data['cityId'] = this.cityId;
    data['stateId'] = this.stateId;
    data['city'] = this.city;
    data['state'] = this.state;
    return data;
  }
}