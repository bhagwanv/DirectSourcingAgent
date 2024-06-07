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
  String? role;
  String? type;

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
      this.leadId,
      this.role,
      this.type});

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
    role = json['role'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['userId'] = userId;
    data['userToken'] = userToken;
    data['isActivated'] = isActivated;
    data['companyCode'] = companyCode;
    data['companyId'] = companyId;
    data['productCode'] = productCode;
    data['productId'] = productId;
    data['leadId'] = leadId;
    data['role'] = role;
    data['type'] = type;
    return data;
  }
}
