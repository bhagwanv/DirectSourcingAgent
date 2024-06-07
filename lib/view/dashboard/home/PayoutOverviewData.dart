class PayoutOverviewData {
  PayoutOverviewData({
      this.totalDisbursedAmount, 
      this.payoutAmount,});

  PayoutOverviewData.fromJson(dynamic json) {
    totalDisbursedAmount = json['totalDisbursedAmount'];
    payoutAmount = json['payoutAmount'];
  }
  int? totalDisbursedAmount;
  int? payoutAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalDisbursedAmount'] = totalDisbursedAmount;
    map['payoutAmount'] = payoutAmount;
    return map;
  }

}