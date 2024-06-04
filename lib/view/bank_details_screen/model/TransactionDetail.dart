import 'CreditDayWiseAmounts.dart';

class TransactionDetail {
  TransactionDetail({
      this.transactionReqNo, 
      this.transactionAmount, 
      this.mobileNo, 
      this.convenionFee, 
      this.gstConvenionFee, 
      this.totalAmount, 
      this.loanAccountId, 
      this.orderNo, 
      this.creditDays, 
      this.availableCreditLimit, 
      this.utilizateLimit, 
      this.invoiceAmount, 
      this.anchorName, 
      this.isPayableByCustomer, 
      this.interestRate, 
      this.creditDayWiseAmounts, 
      this.transactionStatus, 
      this.isAccountActive, 
      this.isBlock, 
      this.isBlockComment, 
      this.anchorCompanyId,});

  TransactionDetail.fromJson(dynamic json) {
    transactionReqNo = json['transactionReqNo'];
    transactionAmount = json['transactionAmount'];
    mobileNo = json['mobileNo'];
    convenionFee = json['convenionFee'];
    gstConvenionFee = json['gstConvenionFee'];
    totalAmount = json['totalAmount'];
    loanAccountId = json['loanAccountId'];
    orderNo = json['orderNo'];
    creditDays = json['creditDays'] != null ? json['creditDays'].cast<int>() : [];
    availableCreditLimit = json['availableCreditLimit'];
    utilizateLimit = json['utilizateLimit'];
    invoiceAmount = json['invoiceAmount'];
    anchorName = json['anchorName'];
    isPayableByCustomer = json['isPayableByCustomer'];
    interestRate = json['interestRate'];
    if (json['creditDayWiseAmounts'] != null) {
      creditDayWiseAmounts = [];
      json['creditDayWiseAmounts'].forEach((v) {
        creditDayWiseAmounts?.add(CreditDayWiseAmounts.fromJson(v));
      });
    }
    transactionStatus = json['transactionStatus'];
    isAccountActive = json['isAccountActive'];
    isBlock = json['isBlock'];
    isBlockComment = json['isBlockComment'];
    anchorCompanyId = json['anchorCompanyId'];
  }
  String? transactionReqNo;
  int? transactionAmount;
  String? mobileNo;
  int? convenionFee;
  int? gstConvenionFee;
  int? totalAmount;
  int? loanAccountId;
  String? orderNo;
  List<int>? creditDays;
  int? availableCreditLimit;
  int? utilizateLimit;
  int? invoiceAmount;
  String? anchorName;
  bool? isPayableByCustomer;
  dynamic interestRate;
  List<CreditDayWiseAmounts>? creditDayWiseAmounts;
  String? transactionStatus;
  bool? isAccountActive;
  bool? isBlock;
  String? isBlockComment;
  int? anchorCompanyId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['transactionReqNo'] = transactionReqNo;
    map['transactionAmount'] = transactionAmount;
    map['mobileNo'] = mobileNo;
    map['convenionFee'] = convenionFee;
    map['gstConvenionFee'] = gstConvenionFee;
    map['totalAmount'] = totalAmount;
    map['loanAccountId'] = loanAccountId;
    map['orderNo'] = orderNo;
    map['creditDays'] = creditDays;
    map['availableCreditLimit'] = availableCreditLimit;
    map['utilizateLimit'] = utilizateLimit;
    map['invoiceAmount'] = invoiceAmount;
    map['anchorName'] = anchorName;
    map['isPayableByCustomer'] = isPayableByCustomer;
    map['interestRate'] = interestRate;
    if (creditDayWiseAmounts != null) {
      map['creditDayWiseAmounts'] = creditDayWiseAmounts?.map((v) => v.toJson()).toList();
    }
    map['transactionStatus'] = transactionStatus;
    map['isAccountActive'] = isAccountActive;
    map['isBlock'] = isBlock;
    map['isBlockComment'] = isBlockComment;
    map['anchorCompanyId'] = anchorCompanyId;
    return map;
  }

}