class LeadCreatePermissionModel {
  bool? status;
  String? message;
  bool? response;

  LeadCreatePermissionModel({this.status, this.message, this.response});

  LeadCreatePermissionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['response'] = this.response;
    return data;
  }
}