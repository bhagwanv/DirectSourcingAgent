class SendOtpOnEmailResponce {
  bool? status;
  String? message;
  String? otp;

  SendOtpOnEmailResponce({this.status, this.message, this.otp});

  SendOtpOnEmailResponce.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    otp = json['otp'];

    // Handle null values
    status ??= false; // Assigns false if status is null
    message ??= "";   // Assigns an empty string if message is null
    otp ??= "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['otp'] = this.otp;
    return data;
  }
}