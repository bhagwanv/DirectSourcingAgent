import 'ReturnObject.dart';

class AllStateResponce {
  AllStateResponce({
    this.status,
    this.message,
    this.returnObject,});

  AllStateResponce.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['returnObject'] != null) {
      returnObject = [];
      json['returnObject'].forEach((v) {
        returnObject?.add(ReturnObject.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<ReturnObject?>? returnObject;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (returnObject != null) {
      map['returnObject'] = returnObject?.map((v) => v?.toJson()).toList();
    }
    return map;
  }

}