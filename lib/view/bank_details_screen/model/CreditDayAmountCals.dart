class CreditDayAmountCals {
  CreditDayAmountCals({
      this.interestRate, 
      this.interestAmount, 
      this.gstAmount, 
      this.totalAmount, 
      this.invoiceAmount, 
      this.annualInterestRate,});

  CreditDayAmountCals.fromJson(dynamic json) {
    interestRate = json['interestRate'];
    interestAmount = json['interestAmount'];
    gstAmount = json['gstAmount'];
    totalAmount = json['totalAmount'];
    invoiceAmount = json['invoiceAmount'];
    annualInterestRate = json['annualInterestRate'];
  }
  dynamic interestRate;
  dynamic interestAmount;
  dynamic gstAmount;
  dynamic totalAmount;
  dynamic invoiceAmount;
  dynamic annualInterestRate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['interestRate'] = interestRate;
    map['interestAmount'] = interestAmount;
    map['gstAmount'] = gstAmount;
    map['totalAmount'] = totalAmount;
    map['invoiceAmount'] = invoiceAmount;
    map['annualInterestRate'] = annualInterestRate;
    return map;
  }

}