class DsaDashboardLeadListReqModel {
  DsaDashboardLeadListReqModel({
      this.agentUserId, 
      this.startDate, 
      this.endDate, 
      this.skip, 
      this.take,});

  DsaDashboardLeadListReqModel.fromJson(dynamic json) {
    agentUserId = json['agentUserId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    skip = json['skip'];
    take = json['take'];
  }
  String? agentUserId;
  String? startDate;
  String? endDate;
  int? skip;
  int? take;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['agentUserId'] = agentUserId;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['skip'] = skip;
    map['take'] = take;
    return map;
  }

}