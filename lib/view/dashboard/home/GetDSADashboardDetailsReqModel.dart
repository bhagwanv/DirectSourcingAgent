class GetDsaDashboardDetailsReqModel {
  GetDsaDashboardDetailsReqModel({
      this.agentUserId, 
      this.startDate, 
      this.endDate,});

  GetDsaDashboardDetailsReqModel.fromJson(dynamic json) {
    agentUserId = json['agentUserId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }
  String? agentUserId;
  String? startDate;
  String? endDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['agentUserId'] = agentUserId;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    return map;
  }

}