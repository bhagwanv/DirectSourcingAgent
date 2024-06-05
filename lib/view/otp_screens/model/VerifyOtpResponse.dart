class VerifyOtpResponse {
  bool? status;
  String? message;
  int? leadId;
  String? userId;
  String? token;

  VerifyOtpResponse({
    this.status,
    this.message,
    this.leadId,
    this.userId,
    this.token});

  VerifyOtpResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    leadId = json['leadId'];
    userId = json['userId'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['leadId'] = leadId;
    map['userId'] = userId;
    map['token'] = token;
    return map;
  }
}