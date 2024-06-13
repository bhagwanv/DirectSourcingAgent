class VerifyOtpResponse {
  bool? status;
  String? message;
  String? userId;
  String? token;

  VerifyOtpResponse({
    this.status,
    this.message,
    this.userId,
    this.token});

  VerifyOtpResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    userId = json['userId'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['userId'] = userId;
    map['token'] = token;
    return map;
  }
}