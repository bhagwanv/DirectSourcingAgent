class PostPersonalDetailsResponseModel {
  int? result;
  bool? isSuccess;
  String? message;
  int? statusCode;


  PostPersonalDetailsResponseModel({this.result, this.isSuccess, this.message, this.statusCode});

  PostPersonalDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    isSuccess = json['isSuccess'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    return data;
  }
}