class LangauageMasterListResponse {
  bool? status;
  String? message;
  List<LangauageMasterList>? returnObject;

  LangauageMasterListResponse({this.status, this.message, this.returnObject});

  LangauageMasterListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['returnObject'] != null) {
      returnObject = <LangauageMasterList>[];
      json['returnObject'].forEach((v) {
        returnObject!.add(new LangauageMasterList.fromJson(v));
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

class LangauageMasterList {
  int? id;
  String? name;

  LangauageMasterList({this.id, this.name});

  LangauageMasterList.fromJson(Map<String, dynamic> json) {
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
  @override
  int toInt() {
    return id!;
  }

}
