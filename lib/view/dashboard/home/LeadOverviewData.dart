class LeadOverviewData {
  LeadOverviewData({
      this.totalLeads, 
      this.pending, 
      this.rejected, 
      this.submitted, 
      this.successRate,});

  LeadOverviewData.fromJson(dynamic json) {
    totalLeads = json['totalLeads'];
    pending = json['pending'];
    rejected = json['rejected'];
    submitted = json['submitted'];
    successRate = json['successRate'];
  }
  int? totalLeads;
  int? pending;
  int? rejected;
  int? submitted;
  dynamic successRate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalLeads'] = totalLeads;
    map['pending'] = pending;
    map['rejected'] = rejected;
    map['submitted'] = submitted;
    map['successRate'] = successRate;
    return map;
  }

}