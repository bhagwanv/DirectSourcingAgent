class EducationMasterListResponse {
  bool? status;
  String? message;
  List<QualificationList>? returnObject;

  EducationMasterListResponse({this.status, this.message, this.returnObject});

  EducationMasterListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['returnObject'] != null) {
      returnObject = <QualificationList>[];
      json['returnObject'].forEach((v) {
        returnObject!.add(new QualificationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.returnObject != null) {
      data['returnObject'] = this.returnObject!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QualificationList {
  int? id;
  String? name;

  QualificationList({this.id, this.name});

  QualificationList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

  @override
  String toString() {
    return name!;
  }

}
