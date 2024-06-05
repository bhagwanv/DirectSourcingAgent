class ProductCompanyDetailResponseModel {
  bool? status;
  String? message = "";
  ProductCompanyDetailResponse? response;

  ProductCompanyDetailResponseModel({this.status, this.message, this.response});

  ProductCompanyDetailResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    response = json['response'] != null
        ? ProductCompanyDetailResponse.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class ProductCompanyDetailResponse {
  dynamic productId;
  String? productCode;
  dynamic companyId;
  String? companyCode;

  ProductCompanyDetailResponse(
      {this.productId, this.productCode, this.companyId, this.companyCode});

  ProductCompanyDetailResponse.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productCode = json['productCode'];
    companyId = json['companyId'];
    companyCode = json['companyCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productCode'] = this.productCode;
    data['companyId'] = this.companyId;
    data['companyCode'] = this.companyCode;
    return data;
  }
}