class BankDetailResult {
  int? leadId;
  String? eNach;
  String? bankName;
  String? ifscCode;
  String? accountType;
  int? activityId;
  Null? subActivityId;
  String? accountNumber;
  String? accountHolderName;
  String? pdfPassword;
  bool? isEnach;
  String? surrogateType;

  BankDetailResult(
      {this.leadId,
        this.eNach,
        this.bankName,
        this.ifscCode,
        this.accountType,
        this.activityId,
        this.subActivityId,
        this.accountNumber,
        this.accountHolderName,
        this.pdfPassword,
        this.isEnach,
        this.surrogateType});

  BankDetailResult.fromJson(Map<String, dynamic> json) {
    leadId = json['leadId'];
    eNach = json['eNach'];
    bankName = json['bankName'];
    ifscCode = json['ifscCode'];
    accountType = json['accountType'];
    activityId = json['activityId'];
    subActivityId = json['subActivityId'];
    accountNumber = json['accountNumber'];
    accountHolderName = json['accountHolderName'];
    pdfPassword = json['pdfPassword'];
    isEnach = json['isEnach'];
    surrogateType = json['surrogateType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leadId'] = this.leadId;
    data['eNach'] = this.eNach;
    data['bankName'] = this.bankName;
    data['ifscCode'] = this.ifscCode;
    data['accountType'] = this.accountType;
    data['activityId'] = this.activityId;
    data['subActivityId'] = this.subActivityId;
    data['accountNumber'] = this.accountNumber;
    data['accountHolderName'] = this.accountHolderName;
    data['pdfPassword'] = this.pdfPassword;
    data['isEnach'] = this.isEnach;
    data['surrogateType'] = this.surrogateType;
    return data;
  }
}