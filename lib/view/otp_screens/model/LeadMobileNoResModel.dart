class LeadMobileNoResModel {
  bool? status;
  String? message;
  int? leadId;

  LeadMobileNoResModel({this.status, this.message, this.leadId});

  LeadMobileNoResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    leadId = json['leadId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['leadId'] = this.leadId;
    return data;
  }
}
