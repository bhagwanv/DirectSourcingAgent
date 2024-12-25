

class ProductWiseCommissions {
  int? productId;
  String? productCode;
  List<Payouts>? payouts;

  ProductWiseCommissions({this.productId, this.productCode, this.payouts});

  ProductWiseCommissions.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productCode = json['productCode'];
    if (json['payouts'] != null) {
      payouts = <Payouts>[];
      json['payouts'].forEach((v) {
        payouts!.add(new Payouts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productCode'] = this.productCode;
    if (this.payouts != null) {
      data['payouts'] = this.payouts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payouts {
  dynamic payoutPercentage;
  dynamic minAmount;
  dynamic maxAmount;

  Payouts({this.payoutPercentage, this.minAmount, this.maxAmount});

  Payouts.fromJson(Map<String, dynamic> json) {
    payoutPercentage = json['payoutPercentage'];
    minAmount = json['minAmount'];
    maxAmount = json['maxAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payoutPercentage'] = this.payoutPercentage;
    data['minAmount'] = this.minAmount;
    data['maxAmount'] = this.maxAmount;
    return data;
  }
}