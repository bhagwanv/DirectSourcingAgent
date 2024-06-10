class CheckESignResponseModel {
  String? msg;
  bool? status;
  String? data;
  bool? isNotEditable;
  String? nameOnCard;
  ArthMateOffer? arthMateOffer;

  CheckESignResponseModel(
      {this.msg,
        this.status,
        this.data,
        this.isNotEditable,
        this.nameOnCard,
        this.arthMateOffer});

  CheckESignResponseModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    data = json['data'];
    isNotEditable = json['isNotEditable'];
    nameOnCard = json['nameOnCard'];
    arthMateOffer = json['arthMateOffer'] != null
        ? new ArthMateOffer.fromJson(json['arthMateOffer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    data['data'] = this.data;
    data['isNotEditable'] = this.isNotEditable;
    data['nameOnCard'] = this.nameOnCard;
    if (this.arthMateOffer != null) {
      data['arthMateOffer'] = this.arthMateOffer!.toJson();
    }
    return data;
  }
}

class ArthMateOffer {
  int? loanAmt;
  int? interestRt;
  int? loanTnr;
  String? loanTnrType;
  int? orignalLoanAmt;
  String? name;

  ArthMateOffer(
      {this.loanAmt,
        this.interestRt,
        this.loanTnr,
        this.loanTnrType,
        this.orignalLoanAmt,
        this.name});

  ArthMateOffer.fromJson(Map<String, dynamic> json) {
    loanAmt = json['loan_amt'];
    interestRt = json['interest_rt'];
    loanTnr = json['loan_tnr'];
    loanTnrType = json['loan_tnr_type'];
    orignalLoanAmt = json['orignal_loan_amt'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loan_amt'] = this.loanAmt;
    data['interest_rt'] = this.interestRt;
    data['loan_tnr'] = this.loanTnr;
    data['loan_tnr_type'] = this.loanTnrType;
    data['orignal_loan_amt'] = this.orignalLoanAmt;
    data['name'] = this.name;
    return data;
  }
}
