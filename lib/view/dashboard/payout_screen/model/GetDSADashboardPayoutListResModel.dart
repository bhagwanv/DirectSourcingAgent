import 'Response.dart';

class GetDsaDashboardPayoutListResModel {
  GetDsaDashboardPayoutListResModel({
      this.status, 
      this.message, 
      this.response,});

  GetDsaDashboardPayoutListResModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    response = json['response'] != null ? Response.fromJson(json['response']) : null;
  }
  bool? status;
  String? message;
  Response? response;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (response != null) {
      map['response'] = response?.toJson();
    }
    return map;
  }

}
