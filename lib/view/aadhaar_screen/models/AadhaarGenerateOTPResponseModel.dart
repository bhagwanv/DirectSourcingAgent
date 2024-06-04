class AadhaarGenerateOTPResponseModel {
  String? requestId;
  int? statusCode;
  ErrorModel? error;
  String? personId;
  Data? data;
  int? errorCode;

  AadhaarGenerateOTPResponseModel({
    this.requestId,
    this.statusCode,
    this.error,
    this.personId,
    this.data,
    this.errorCode,
  });

  AadhaarGenerateOTPResponseModel.fromJson(dynamic json) {
    requestId = json['requestId'];
    statusCode = json['statusCode'];
    error = json['error'];
    personId = json['personId'];
    data = Data.fromJson(json['result']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['requestId'] = requestId;
    map['statusCode'] = statusCode;
    map['error'] = error;
    map['personId'] = personId;
    map['result'] = data?.toJson();
    return map;
  }
}

class Data {
  String? message;

  Data({this.message});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}

class ErrorModel {
  Error? error;
  ErrorModel({this.error});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    error = json['error'] != null ? new Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.error != null) {
      data['error'] = this.error!.toJson();
    }
    return data;
  }
}

class Error {
  var requestId;
  var status;
  String? message;
  var error;

  Error({this.requestId, this.status, this.message, this.error});

  Error.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    status = json['status'];
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    data['status'] = this.status;
    data['message'] = this.message;
    data['error'] = this.error;
    return data;
  }
}
