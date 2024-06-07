class CreateDSAUserReqModel {
  String? mobileNumber;
  String? fullName;
  String? emailId;
  int? payoutPercenatge;

  CreateDSAUserReqModel(
      {this.mobileNumber, this.fullName, this.emailId, this.payoutPercenatge});

  CreateDSAUserReqModel.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobileNumber'];
    fullName = json['fullName'];
    emailId = json['emailId'];
    payoutPercenatge = json['payoutPercenatge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobileNumber'] = this.mobileNumber;
    data['fullName'] = this.fullName;
    data['emailId'] = this.emailId;
    data['payoutPercenatge'] = this.payoutPercenatge;
    return data;
  }
}