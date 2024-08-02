class LoanPayoutDetailList {
  LoanPayoutDetailList({
      this.loanId, 
      this.disbursmentDate, 
      this.fullName, 
      this.status, 
      this.mobileNo, 
      this.disbursmentAmount, 
      this.payoutAmount, 
      this.profileImage,});

  LoanPayoutDetailList.fromJson(dynamic json) {
    loanId = json['loanId'];
    disbursmentDate = json['disbursmentDate'];
    fullName = json['fullName'];
    status = json['status'];
    mobileNo = json['mobileNo'];
    disbursmentAmount = json['disbursmentAmount'];
    payoutAmount = json['payoutAmount'];
    profileImage = json['profileImage'];
  }
  String? loanId;
  String? disbursmentDate;
  String? fullName;
  String? status;
  String? mobileNo;
  dynamic disbursmentAmount;
  dynamic payoutAmount;
  String? profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['loanId'] = loanId;
    map['disbursmentDate'] = disbursmentDate;
    map['fullName'] = fullName;
    map['status'] = status;
    map['mobileNo'] = mobileNo;
    map['disbursmentAmount'] = disbursmentAmount;
    map['payoutAmount'] = payoutAmount;
    map['profileImage'] = profileImage;
    return map;
  }

}