import 'LeadOverviewData.dart';
import 'LoanOverviewData.dart';
import 'PayoutOverviewData.dart';

class Response {
  Response({
      this.leadOverviewData, 
      this.loanOverviewData, 
      this.payoutOverviewData,});

  Response.fromJson(dynamic json) {
    leadOverviewData = json['leadOverviewData'] != null ? LeadOverviewData.fromJson(json['leadOverviewData']) : null;
    loanOverviewData = json['loanOverviewData'] != null ? LoanOverviewData.fromJson(json['loanOverviewData']) : null;
    payoutOverviewData = json['payoutOverviewData'] != null ? PayoutOverviewData.fromJson(json['payoutOverviewData']) : null;
  }
  LeadOverviewData? leadOverviewData;
  LoanOverviewData? loanOverviewData;
  PayoutOverviewData? payoutOverviewData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (leadOverviewData != null) {
      map['leadOverviewData'] = leadOverviewData?.toJson();
    }
    if (loanOverviewData != null) {
      map['loanOverviewData'] = loanOverviewData?.toJson();
    }
    if (payoutOverviewData != null) {
      map['payoutOverviewData'] = payoutOverviewData?.toJson();
    }
    return map;
  }

}