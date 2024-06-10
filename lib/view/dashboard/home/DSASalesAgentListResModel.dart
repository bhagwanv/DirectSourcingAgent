import 'Result.dart';

class DsaSalesAgentListResModel {
  DsaSalesAgentListResModel({
      this.result, 
      this.isSuccess, 
      this.message,});

  DsaSalesAgentListResModel.fromJson(dynamic json) {
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(Result.fromJson(v));
      });
    }
    isSuccess = json['isSuccess'];
    message = json['message'];
  }
  List<Result>? result;
  bool? isSuccess;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (result != null) {
      map['result'] = result?.map((v) => v.toJson()).toList();
    }
    map['isSuccess'] = isSuccess;
    map['message'] = message;
    return map;
  }

}