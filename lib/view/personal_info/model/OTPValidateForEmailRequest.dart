class OtpValidateForEmailRequest {
  OtpValidateForEmailRequest({
      this.email, 
      this.otp,});

  OtpValidateForEmailRequest.fromJson(dynamic json) {
    email = json['Email'];
    otp = json['OTP'];
  }
  String? email;
  String? otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Email'] = email;
    map['OTP'] = otp;
    return map;
  }

}