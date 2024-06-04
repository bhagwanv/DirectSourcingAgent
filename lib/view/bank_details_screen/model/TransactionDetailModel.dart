import 'TransactionDetail.dart';

class TransactionDetailModel {
  TransactionDetailModel({
      this.status, 
      this.message, 
      this.response,});

  TransactionDetailModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    response = json['response'] != null ? TransactionDetail.fromJson(json['response']) : null;
  }
  bool? status;
  String? message;
  TransactionDetail? response;

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