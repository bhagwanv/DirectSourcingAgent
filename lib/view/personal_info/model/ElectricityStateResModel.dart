class ElectricityStateResModel {
  ElectricityStateResModel({
      this.districtName, 
      this.state, 
      this.districtCode,});

  ElectricityStateResModel.fromJson(dynamic json) {
    districtName = json['districtName'];
    state = json['state'];
    districtCode = json['districtCode'];
  }
  String? districtName;
  String? state;
  int? districtCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['districtName'] = districtName;
    map['state'] = state;
    map['districtCode'] = districtCode;
    return map;
  }

}