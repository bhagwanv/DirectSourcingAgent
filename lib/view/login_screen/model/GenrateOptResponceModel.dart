class GenrateOptResponceModel {
  bool? status;
  String? message;
  String? otp;
  int? statusCode;

  GenrateOptResponceModel(
      {this.status, this.message, this.otp, this.statusCode});

  GenrateOptResponceModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['otp'] = otp;
    return map;
  }
}
