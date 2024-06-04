class CityResponce {
  CityResponce({
      this.id, 
      this.name, 
      this.shortName,});

  CityResponce.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    shortName = json['shortName'];
  }
  int? id;
  String? name;
  String? shortName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['shortName'] = shortName;
    return map;
  }

}