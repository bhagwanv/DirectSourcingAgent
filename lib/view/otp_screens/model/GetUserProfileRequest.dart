class GetUserProfileRequest {
  String? mobileNumber;
  String? userId;
  int? leadId;

  GetUserProfileRequest({
    this.mobileNumber,
    this.userId,
    this.leadId,
  });

  GetUserProfileRequest.fromJson(dynamic json) {
    mobileNumber = json['mobileNumber'];
    userId = json['userId'];
    leadId = json['leadId'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobileNumber'] = mobileNumber;
    map['userId'] = userId;
    map['leadId'] = leadId;
    return map;
  }
}
