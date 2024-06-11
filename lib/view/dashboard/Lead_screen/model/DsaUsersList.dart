class DsaUsersList {
  DsaUsersList({
      this.userId, 
      this.fullName, 
      this.mobileNo, 
      this.createdDate, 
      this.emailId, 
      this.payoutPercenatge, 
      this.status, 
      this.anchorCompanyId, 
      this.type, 
      this.role, 
      this.agreementStatDate, 
      this.agreementEndDate,});

  DsaUsersList.fromJson(dynamic json) {
    userId = json['userId'];
    fullName = json['fullName'];
    mobileNo = json['mobileNo'];
    createdDate = json['createdDate'];
    emailId = json['emailId'];
    payoutPercenatge = json['payoutPercenatge'];
    status = json['status'];
    anchorCompanyId = json['anchorCompanyId'];
    type = json['type'];
    role = json['role'];
    agreementStatDate = json['agreementStatDate'];
    agreementEndDate = json['agreementEndDate'];
  }
  String? userId;
  String? fullName;
  String? mobileNo;
  String? createdDate;
  String? emailId;
  int? payoutPercenatge;
  bool? status;
  int? anchorCompanyId;
  String? type;
  String? role;
  String? agreementStatDate;
  String? agreementEndDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['fullName'] = fullName;
    map['mobileNo'] = mobileNo;
    map['createdDate'] = createdDate;
    map['emailId'] = emailId;
    map['payoutPercenatge'] = payoutPercenatge;
    map['status'] = status;
    map['anchorCompanyId'] = anchorCompanyId;
    map['type'] = type;
    map['role'] = role;
    map['agreementStatDate'] = agreementStatDate;
    map['agreementEndDate'] = agreementEndDate;
    return map;
  }

}