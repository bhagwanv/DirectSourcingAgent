import 'LoanPayoutDetailList.dart';

class Response {
  Response({
      this.totalDisbursedAmount, 
      this.totalPayoutAmount, 
      this.totalRecords, 
      this.loanPayoutDetailList,});

  Response.fromJson(dynamic json) {
    totalDisbursedAmount = json['totalDisbursedAmount'];
    totalPayoutAmount = json['totalPayoutAmount'];
    totalRecords = json['totalRecords'];
    if (json['loanPayoutDetailList'] != null) {
      loanPayoutDetailList = [];
      json['loanPayoutDetailList'].forEach((v) {
        loanPayoutDetailList?.add(LoanPayoutDetailList.fromJson(v));
      });
    }
  }
  dynamic totalDisbursedAmount;
  dynamic totalPayoutAmount;
  dynamic totalRecords;
  List<LoanPayoutDetailList>? loanPayoutDetailList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalDisbursedAmount'] = totalDisbursedAmount;
    map['totalPayoutAmount'] = totalPayoutAmount;
    map['totalRecords'] = totalRecords;
    if (loanPayoutDetailList != null) {
      map['loanPayoutDetailList'] = loanPayoutDetailList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}