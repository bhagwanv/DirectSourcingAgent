import 'DsaDashboardLeadList.dart';

class DsaDashboardLeadListResModel {
  DsaDashboardLeadListResModel({
      this.status, 
      this.message, 
      this.response,});

  DsaDashboardLeadListResModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['response'] != null) {
      response = [];
      json['response'].forEach((v) {
        response?.add(DsaDashboardLeadList.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<DsaDashboardLeadList>? response;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (response != null) {
      map['response'] = response?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}