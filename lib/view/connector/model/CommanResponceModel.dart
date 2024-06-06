class CommanResponceModel {
  int? result;
  bool? isSuccess;
  String? message;

  CommanResponceModel({this.result, this.isSuccess, this.message});

  CommanResponceModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    isSuccess = json['isSuccess'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    return data;
  }
}