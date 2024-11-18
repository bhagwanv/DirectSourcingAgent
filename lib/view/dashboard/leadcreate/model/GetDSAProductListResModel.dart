class GetDSAProductListResModel {
  List<GetDSAProductList>? result;
  bool? isSuccess;
  String? message;

  GetDSAProductListResModel({this.result, this.isSuccess, this.message});

  GetDSAProductListResModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <GetDSAProductList>[];
      json['result'].forEach((v) {
        result!.add(new GetDSAProductList.fromJson(v));
      });
    }
    isSuccess = json['isSuccess'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    return data;
  }
}

class GetDSAProductList {
  int? productId;
  String? productName;
  String? productCode;
  String? productType;

  GetDSAProductList(
      {this.productId, this.productName, this.productCode, this.productType});

  GetDSAProductList.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productCode = json['productCode'];
    productType = json['productType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productCode'] = this.productCode;
    data['productType'] = this.productType;
    return data;
  }
}