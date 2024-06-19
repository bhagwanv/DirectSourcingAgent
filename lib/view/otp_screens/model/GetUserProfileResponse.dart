class GetUserProfileResponse {
  bool? status;
  String? message;
  String? userId;
  String? userToken;
  bool? isActivated;
  String? companyCode;
  int? companyId;
  String? productCode;
  int? productId;
  String? role;
  String? type;
  UserData? userData;

  GetUserProfileResponse(
      {this.status,
        this.message,
        this.userId,
        this.userToken,
        this.isActivated,
        this.companyCode,
        this.companyId,
        this.productCode,
        this.productId,
        this.role,
        this.type,
        this.userData});

  GetUserProfileResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['userId'];
    userToken = json['userToken'];
    isActivated = json['isActivated'];
    companyCode = json['companyCode'];
    companyId = json['companyId'];
    productCode = json['productCode'];
    productId = json['productId'];
    role = json['role'];
    type = json['type'];
    userData = json['userData'] != null
        ? new UserData.fromJson(json['userData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['userId'] = this.userId;
    data['userToken'] = this.userToken;
    data['isActivated'] = this.isActivated;
    data['companyCode'] = this.companyCode;
    data['companyId'] = this.companyId;
    data['productCode'] = this.productCode;
    data['productId'] = this.productId;
    data['role'] = this.role;
    data['type'] = this.type;
    if (this.userData != null) {
      data['userData'] = this.userData!.toJson();
    }
    return data;
  }
}

class UserData {
  String? name;
  String? panNumber;
  String? aadharNumber;
  String? mobile;
  String? address;
  String? workingLocation;
  String? selfie;
  double? payout;
  String? docSignedUrl;
  String? startedOn;
  String? expiredOn;

  UserData(
      {this.name,
        this.panNumber,
        this.aadharNumber,
        this.mobile,
        this.address,
        this.workingLocation,
        this.selfie,
        this.payout,
      this.docSignedUrl,
      this.startedOn,
      this.expiredOn});

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    panNumber = json['panNumber'];
    aadharNumber = json['aadharNumber'];
    mobile = json['mobile'];
    address = json['address'];
    workingLocation = json['workingLocation'];
    selfie = json['selfie'];
    payout = json['payout'];
    docSignedUrl = json['docSignedUrl'];
    startedOn = json['startedOn'];
    expiredOn = json['expiredOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['panNumber'] = this.panNumber;
    data['aadharNumber'] = this.aadharNumber;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['workingLocation'] = this.workingLocation;
    data['selfie'] = this.selfie;
    data['payout'] = this.payout;
    data['docSignedUrl'] = this.docSignedUrl;
    data['startedOn'] = this.startedOn;
    data['expiredOn'] = this.expiredOn;
    return data;
  }
}