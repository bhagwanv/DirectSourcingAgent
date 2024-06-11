class DsaSalesAgentList {
  DsaSalesAgentList({
      this.userId, 
      this.mobileNo, 
      this.anchorCompanyId, 
      this.type, 
      this.fullName, 
      this.payoutPercenatge, 
      this.role, 
      this.agreementStartDate, 
      this.agreementEndDate,});

  DsaSalesAgentList.fromJson(dynamic json) {
    userId = json['userId'];
    mobileNo = json['mobileNo'];
    anchorCompanyId = json['anchorCompanyId'];
    type = json['type'];
    fullName = json['fullName'];
    payoutPercenatge = json['payoutPercenatge'];
    role = json['role'];
    agreementStartDate = json['agreementStartDate'];
    agreementEndDate = json['agreementEndDate'];
  }
  String? userId;
  String? mobileNo;
  int? anchorCompanyId;
  String? type;
  String? fullName;
  int? payoutPercenatge = 0;
  String? role;
  String? agreementStartDate="";
  String? agreementEndDate="";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['mobileNo'] = mobileNo;
    map['anchorCompanyId'] = anchorCompanyId;
    map['type'] = type;
    map['fullName'] = fullName;
    map['payoutPercenatge'] = payoutPercenatge;
    map['role'] = role;
    map['agreementStartDate'] = agreementStartDate;
    map['agreementEndDate'] = agreementEndDate;
    return map;
  }

}