class LeadAadhaarResponse {
  String? frontImageUrl;
  String? backImageUrl;
  String? documentNumber;
  int? frontDocumentId;
  int? backDocumentId;

  LeadAadhaarResponse({
    this.frontImageUrl,
    this.backImageUrl,
    this.documentNumber,
    this.frontDocumentId,
    this.backDocumentId
  });

  LeadAadhaarResponse.fromJson(dynamic json) {
    frontImageUrl = json['frontImageUrl'];
    backImageUrl = json['backImageUrl'];
    documentNumber = json['documentNumber'];
    frontDocumentId = json['frontDocumentId'];
    backDocumentId = json['backDocumentId'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['frontImageUrl'] = frontImageUrl;
    map['backImageUrl'] = backImageUrl;
    map['documentNumber'] = documentNumber;
    map['frontDocumentId'] = frontDocumentId;
    map['backDocumentId'] = backDocumentId;
    return map;
  }
}