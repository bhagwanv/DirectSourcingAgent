class ChooseUserTypeRequestModel {
  int? leadId;
  int? activityId;
  int? subActivityId;
  String? userId;
  int? companyId;
  String? dsaType;

  ChooseUserTypeRequestModel(
      {this.leadId,
        this.activityId,
        this.subActivityId,
        this.userId,
        this.companyId,
        this.dsaType});

  ChooseUserTypeRequestModel.fromJson(Map<String, dynamic> json) {
    leadId = json['leadId'];
    activityId = json['activityId'];
    subActivityId = json['subActivityId'];
    userId = json['userId'];
    companyId = json['companyId'];
    dsaType = json['dsaType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leadId'] = this.leadId;
    data['activityId'] = this.activityId;
    data['subActivityId'] = this.subActivityId;
    data['userId'] = this.userId;
    data['companyId'] = this.companyId;
    data['dsaType'] = this.dsaType;
    return data;
  }
}