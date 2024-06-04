class VarifayOtpRequest {
  VarifayOtpRequest({
    this.activityId,
    this.companyId,
    this.mobileNo,
    this.otp,
    this.productId,
    this.subActivityId,
    this.vintageDays,
    this.monthlyAvgBuying,
    this.screen,
    this.ProductCode,
    this.CompanyCode,
  });

  VarifayOtpRequest.fromJson(dynamic json) {
    activityId = json['ActivityId'];
    companyId = json['CompanyId'];
    mobileNo = json['MobileNo'];
    otp = json['OTP'];
    productId = json['ProductId'];
    subActivityId = json['SubActivityId'];
    vintageDays = json['VintageDays'];
    monthlyAvgBuying = json['MonthlyAvgBuying'];
    screen = json['Screen'];
    ProductCode = json['ProductCode'];
    CompanyCode = json['CompanyCode'];
  }

  int? activityId;
  int? companyId;
  String? mobileNo;
  String? otp;
  int? productId;
  int? subActivityId;
  int? vintageDays;
  int? monthlyAvgBuying;
  String? screen;
  String? ProductCode;
  String? CompanyCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ActivityId'] = activityId;
    map['CompanyId'] = companyId;
    map['MobileNo'] = mobileNo;
    map['OTP'] = otp;
    map['ProductId'] = productId;
    map['SubActivityId'] = subActivityId;
    map['VintageDays'] = vintageDays;
    map['MonthlyAvgBuying'] = monthlyAvgBuying;
    map['Screen'] = screen;
    map['ProductCode'] = ProductCode;
    map['CompanyCode'] = CompanyCode;
    return map;
  }
}

//old DC
/*
class VarifayOtpRequest {
  VarifayOtpRequest({
    this.activityId,
    this.companyId,
    this.mobileNo,
    this.otp,
    this.productId,
    this.subActivityId,
    this.vintageDays,
    this.monthlyAvgBuying,
    this.screen,});

  VarifayOtpRequest.fromJson(dynamic json) {
    activityId = json['ActivityId'];
    companyId = json['CompanyId'];
    mobileNo = json['MobileNo'];
    otp = json['OTP'];
    productId = json['ProductId'];
    subActivityId = json['SubActivityId'];
    vintageDays = json['VintageDays'];
    monthlyAvgBuying = json['MonthlyAvgBuying'];
    screen = json['Screen'];
  }
  int? activityId;
  int? companyId;
  String? mobileNo;
  String? otp;
  int? productId;
  int? subActivityId;
  int? vintageDays;
  int? monthlyAvgBuying;
  String? screen;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ActivityId'] = activityId;
    map['CompanyId'] = companyId;
    map['MobileNo'] = mobileNo;
    map['OTP'] = otp;
    map['ProductId'] = productId;
    map['SubActivityId'] = subActivityId;
    map['VintageDays'] = vintageDays;
    map['MonthlyAvgBuying'] = monthlyAvgBuying;
    map['Screen'] = screen;
    return map;
  }

}*/
