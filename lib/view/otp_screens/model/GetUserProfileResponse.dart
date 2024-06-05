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
  int? leadId;

  GetUserProfileResponse({
    this.status,
    this.message,
    this.userId,
    this.userToken,
    this.isActivated,
    this.companyCode,
    this.companyId,
    this.productCode,
    this.productId,
    this.leadId
  });

  GetUserProfileResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    userId = json['userId'];
    userToken = json['userToken'];
    isActivated = json['isActivated'];
    companyCode = json['companyCode'];
    companyId = json['companyId'];
    productCode = json['productCode'];
    productId = json['productId'];
    leadId = json['leadId'];
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
    data['leadId'] = this.leadId;
    return data;
  }
}
