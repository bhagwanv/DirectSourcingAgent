class VerifyOtpResponce {
  VerifyOtpResponce({
      this.status, 
      this.message, 
      this.leadId, 
      this.productType, 
      this.userId, 
      this.userTokan,});

  VerifyOtpResponce.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    leadId = json['leadId'];
    productType = json['productType'];
    userId = json['userId'];
    userTokan = json['userTokan'];
  }
  bool? status;
  String? message;
  int? leadId;
  String? productType;
  String? userId;
  String? userTokan;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['leadId'] = leadId;
    map['productType'] = productType;
    map['userId'] = userId;
    map['userTokan'] = userTokan;
    return map;
  }

}