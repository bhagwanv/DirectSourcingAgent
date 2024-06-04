class ElectricityAuthenticationResModel {
  ElectricityAuthenticationResModelResult? result;
  String? requestId;
  String? statusCode;
  ClientData? clientData;
  String? error;

  ElectricityAuthenticationResModel(
      {this.result,
        this.requestId,
        this.statusCode,
        this.clientData,
        this.error});

  ElectricityAuthenticationResModel.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new ElectricityAuthenticationResModelResult.fromJson(json['result']) : null;
    requestId = json['request_id'];
    statusCode = json['statusCode'];
    clientData = json['clientData'] != null
        ? new ClientData.fromJson(json['clientData'])
        : null;
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['request_id'] = this.requestId;
    data['statusCode'] = this.statusCode;
    if (this.clientData != null) {
      data['clientData'] = this.clientData!.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}

class ElectricityAuthenticationResModelResult {
  String? billNo;
  String? billDueDate;
  String? consumerNumber;
  String? billAmount;
  String? billIssueDate;
  String? consumerName;
  String? mobileNumber;
  String? amountPayable;
  String? totalAmount;
  String? address;
  String? emailAddress;
  String? billDate;

  ElectricityAuthenticationResModelResult(
      {this.billNo,
        this.billDueDate,
        this.consumerNumber,
        this.billAmount,
        this.billIssueDate,
        this.consumerName,
        this.mobileNumber,
        this.amountPayable,
        this.totalAmount,
        this.address,
        this.emailAddress,
        this.billDate});

  ElectricityAuthenticationResModelResult.fromJson(Map<String, dynamic> json) {
    billNo = json['bill_no'];
    billDueDate = json['bill_due_date'];
    consumerNumber = json['consumer_number'];
    billAmount = json['bill_amount'];
    billIssueDate = json['bill_issue_date'];
    consumerName = json['consumer_name'];
    mobileNumber = json['mobile_number'];
    amountPayable = json['amount_payable'];
    totalAmount = json['total_amount'];
    address = json['address'];
    emailAddress = json['email_address'];
    billDate = json['bill_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bill_no'] = this.billNo;
    data['bill_due_date'] = this.billDueDate;
    data['consumer_number'] = this.consumerNumber;
    data['bill_amount'] = this.billAmount;
    data['bill_issue_date'] = this.billIssueDate;
    data['consumer_name'] = this.consumerName;
    data['mobile_number'] = this.mobileNumber;
    data['amount_payable'] = this.amountPayable;
    data['total_amount'] = this.totalAmount;
    data['address'] = this.address;
    data['email_address'] = this.emailAddress;
    data['bill_date'] = this.billDate;
    return data;
  }
}

class ClientData {
  String? caseId;

  ClientData({this.caseId});

  ClientData.fromJson(Map<String, dynamic> json) {
    caseId = json['caseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['caseId'] = this.caseId;
    return data;
  }
}