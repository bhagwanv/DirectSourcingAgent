class LeadCurrentRequestModel {
  LeadCurrentRequestModel({
      this.companyId, 
      this.productId, 
      this.leadId, 
      this.mobileNo, 
      this.activityId, 
      this.subActivityId, 
      this.userId, 
      this.monthlyAvgBuying, 
      this.vintageDays, 
      this.isEditable,});

  LeadCurrentRequestModel.fromJson(dynamic json) {
    companyId = json['companyId'];
    productId = json['productId'];
    leadId = json['leadId'];
    mobileNo = json['mobileNo'];
    activityId = json['activityId'];
    subActivityId = json['subActivityId'];
    userId = json['UserId'];
    monthlyAvgBuying = json['MonthlyAvgBuying'];
    vintageDays = json['VintageDays'];
    isEditable = json['IsEditable'];
  }
  int? companyId;
  int? productId;
  int? leadId;
  String? mobileNo;
  int? activityId;
  int? subActivityId;
  String? userId;
  int? monthlyAvgBuying;
  int? vintageDays;
  bool? isEditable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['companyId'] = companyId;
    map['productId'] = productId;
    map['leadId'] = leadId;
    map['mobileNo'] = mobileNo;
    map['activityId'] = activityId;
    map['subActivityId'] = subActivityId;
    map['UserId'] = userId;
    map['MonthlyAvgBuying'] = monthlyAvgBuying;
    map['VintageDays'] = vintageDays;
    map['IsEditable'] = isEditable;
    return map;
  }

}