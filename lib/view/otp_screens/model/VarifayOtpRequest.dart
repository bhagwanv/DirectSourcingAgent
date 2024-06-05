class VarifayOtpRequest {
  String? mobileNo;
  String? otp;


  VarifayOtpRequest({
    this.mobileNo,
    this.otp,
  });

  VarifayOtpRequest.fromJson(dynamic json) {
    mobileNo = json['mobileNo'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobileNo'] = mobileNo;
    map['otp'] = otp;
    return map;
  }
}
