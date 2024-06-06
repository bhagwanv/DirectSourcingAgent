class AggrementDetailsResponce {
  AggrementDetailsResponce({
      this.response, 
      this.isUrl, 
      this.message, 
      this.status,});

  AggrementDetailsResponce.fromJson(dynamic json) {
    response = json['response'];
    isUrl = json['isUrl'];
    message = json['message'];
    status = json['status'];
  }
  String? response;
  bool? isUrl;
  dynamic message;
  bool? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response'] = response;
    map['isUrl'] = isUrl;
    map['message'] = message;
    map['status'] = status;
    return map;
  }

}