class DSAPersonalInfoModel {
  String? dsaType;
  bool? status;
  String? message;

  DSAPersonalInfoModel({this.dsaType, this.status, this.message});

  DSAPersonalInfoModel.fromJson(Map<String, dynamic> json) {
    dsaType = json['dsaType'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dsaType'] = this.dsaType;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}