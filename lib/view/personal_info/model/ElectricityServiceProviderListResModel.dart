class ElectricityServiceProviderListResModel {
  ElectricityServiceProviderListResModel({
      this.state, 
      this.serviceProvider, 
      this.code,});

  ElectricityServiceProviderListResModel.fromJson(dynamic json) {
    state = json['state'];
    serviceProvider = json['serviceProvider'];
    code = json['code'];
  }
  String? state;
  String? serviceProvider;
  String? code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['state'] = state;
    map['serviceProvider'] = serviceProvider;
    map['code'] = code;
    return map;
  }

}