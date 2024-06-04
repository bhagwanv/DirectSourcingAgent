class ElectricityAuthenticationReqModel {
  ElectricityAuthenticationReqModel({
      this.consumerId, 
      this.consent, 
      this.district, 
      this.serviceProvider, 
      this.clientData,});

  ElectricityAuthenticationReqModel.fromJson(dynamic json) {
    consumerId = json['consumer_id'];
    consent = json['consent'];
    district = json['district'];
    serviceProvider = json['service_provider'];
    clientData = json['clientData'] != null ? ClientData.fromJson(json['clientData']) : null;
  }
  String? consumerId;
  String? consent;
  String? district;
  String? serviceProvider;
  ClientData? clientData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['consumer_id'] = consumerId;
    map['consent'] = consent;
    map['district'] = district;
    map['service_provider'] = serviceProvider;
    if (clientData != null) {
      map['clientData'] = clientData?.toJson();
    }
    return map;
  }

}

class ClientData {
  ClientData({
    this.caseId,});

  ClientData.fromJson(dynamic json) {
    caseId = json['caseId'];
  }
  String? caseId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['caseId'] = caseId;
    return map;
  }

}