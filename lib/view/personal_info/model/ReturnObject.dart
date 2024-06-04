class ReturnObject {
  ReturnObject({
      this.name, 
      this.stateCode, 
      this.countryId, 
      this.country, 
      this.cities, 
      this.id, 
      this.created, 
      this.createdBy, 
      this.lastModified, 
      this.lastModifiedBy, 
      this.deleted, 
      this.deletedBy, 
      this.isActive, 
      this.isDeleted,});

  ReturnObject.fromJson(dynamic json) {
    name = json['name'];
    stateCode = json['stateCode'];
    countryId = json['countryId'];
    country = json['country'];
    cities = json['cities'];
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    lastModified = json['lastModified'];
    lastModifiedBy = json['lastModifiedBy'];
    deleted = json['deleted'];
    deletedBy = json['deletedBy'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];

  }
  String? name;
  String? stateCode;
  int? countryId;
  dynamic country;
  dynamic cities;
  int? id;
  String? created;
  dynamic createdBy;
  dynamic lastModified;
  dynamic lastModifiedBy;
  dynamic deleted;
  dynamic deletedBy;
  bool? isActive;
  bool? isDeleted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['stateCode'] = stateCode;
    map['countryId'] = countryId;
    map['country'] = country;
    map['cities'] = cities;
    map['id'] = id;
    map['created'] = created;
    map['createdBy'] = createdBy;
    map['lastModified'] = lastModified;
    map['lastModifiedBy'] = lastModifiedBy;
    map['deleted'] = deleted;
    map['deletedBy'] = deletedBy;
    map['isActive'] = isActive;
    map['isDeleted'] = isDeleted;

    return map;
  }

}