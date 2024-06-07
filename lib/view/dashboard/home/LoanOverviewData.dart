class LoanOverviewData {
  LoanOverviewData({
      this.totalLoans, 
      this.pending, 
      this.approved, 
      this.rejected, 
      this.successRate,});

  LoanOverviewData.fromJson(dynamic json) {
    totalLoans = json['totalLoans'];
    pending = json['pending'];
    approved = json['approved'];
    rejected = json['rejected'];
    successRate = json['successRate'];
  }
  int? totalLoans;
  int? pending;
  int? approved;
  int? rejected;
  dynamic successRate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalLoans'] = totalLoans;
    map['pending'] = pending;
    map['approved'] = approved;
    map['rejected'] = rejected;
    map['successRate'] = successRate;
    return map;
  }

}