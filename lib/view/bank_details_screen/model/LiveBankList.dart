class LiveBankList {
  LiveBankList({
      this.aadhaarActiveFrom, 
      this.aadhaarFlag, 
      this.bankId, 
      this.activeFrm, 
      this.debitcardFlag, 
      this.bankName, 
      this.dcActiveFrom, 
      this.netbankFlag,});

  LiveBankList.fromJson(dynamic json) {
    aadhaarActiveFrom = json['aadhaarActiveFrom'];
    aadhaarFlag = json['aadhaarFlag'];
    bankId = json['bankId'];
    activeFrm = json['activeFrm'];
    debitcardFlag = json['debitcardFlag'];
    bankName = json['bankName'];
    dcActiveFrom = json['dcActiveFrom'];
    netbankFlag = json['netbankFlag'];
  }
  dynamic aadhaarActiveFrom;
  dynamic aadhaarFlag;
  String? bankId;
  String? activeFrm;
  String? debitcardFlag;
  String? bankName;
  String? dcActiveFrom;
  String? netbankFlag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['aadhaarActiveFrom'] = aadhaarActiveFrom;
    map['aadhaarFlag'] = aadhaarFlag;
    map['bankId'] = bankId;
    map['activeFrm'] = activeFrm;
    map['debitcardFlag'] = debitcardFlag;
    map['bankName'] = bankName;
    map['dcActiveFrom'] = dcActiveFrom;
    map['netbankFlag'] = netbankFlag;
    return map;
  }

}