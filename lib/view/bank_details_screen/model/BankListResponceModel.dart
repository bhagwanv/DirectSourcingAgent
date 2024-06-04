import 'LiveBankList.dart';

class BankListResponceModel {
  BankListResponceModel({
      this.liveBankList,});

  BankListResponceModel.fromJson(dynamic json) {
    if (json['liveBankList'] != null) {
      liveBankList = [];
      json['liveBankList'].forEach((v) {
        liveBankList?.add(LiveBankList.fromJson(v));
      });
    }
  }
  List<LiveBankList>? liveBankList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (liveBankList != null) {
      map['liveBankList'] = liveBankList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}