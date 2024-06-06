class Result {
  Result({
      this.productId, 
      this.productCode, 
      this.userName, 
      this.mobileNo, 
      this.leadCode, 
      this.offerCompanyId, 
      this.creditLimit, 
      this.processingFee, 
      this.creditScore, 
      this.cibilReport, 
      this.companyLeads, 
      this.leadActivityMasterProgresses, 
      this.leadOffers, 
      this.isAgreementAccept, 
      this.agreementDate, 
      this.status, 
      this.leadBankDetail, 
      this.cityId, 
      this.applicantName, 
      this.leadGenerator, 
      this.leadConverter, 
      this.id, 
      this.created, 
      this.createdBy, 
      this.lastModified, 
      this.lastModifiedBy, 
      this.deleted, 
      this.deletedBy, 
      this.isActive, 
      this.isDeleted, 
  });

  Result.fromJson(dynamic json) {
    productId = json['productId'];
    productCode = json['productCode'];
    userName = json['userName'];
    mobileNo = json['mobileNo'];
    leadCode = json['leadCode'];
    offerCompanyId = json['offerCompanyId'];
    creditLimit = json['creditLimit'];
    processingFee = json['processingFee'];
    creditScore = json['creditScore'];
    cibilReport = json['cibilReport'];
    companyLeads = json['companyLeads'];
    leadActivityMasterProgresses = json['leadActivityMasterProgresses'];
    leadOffers = json['leadOffers'];
    isAgreementAccept = json['isAgreementAccept'];
    agreementDate = json['agreementDate'];
    status = json['status'];
    leadBankDetail = json['leadBankDetail'];
    cityId = json['cityId'];
    applicantName = json['applicantName'];
    leadGenerator = json['leadGenerator'];
    leadConverter = json['leadConverter'];
    id = json['id'];
    created = json['created'];
    createdBy = json['createdBy'];
    lastModified = json['lastModified'];
    lastModifiedBy = json['lastModifiedBy'];
    deleted = json['deleted'];
    deletedBy = json['deletedBy'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];

  }
  int? productId;
  String? productCode;
  String? userName;
  String? mobileNo;
  String? leadCode;
  dynamic offerCompanyId;
  dynamic creditLimit;
  dynamic processingFee;
  dynamic creditScore;
  String? cibilReport;
  dynamic companyLeads;
  dynamic leadActivityMasterProgresses;
  dynamic leadOffers;
  dynamic isAgreementAccept;
  dynamic agreementDate;
  String? status;
  dynamic leadBankDetail;
  int? cityId;
  String? applicantName;
  dynamic leadGenerator;
  dynamic leadConverter;
  int? id;
  String? created;
  dynamic createdBy;
  String? lastModified;
  String? lastModifiedBy;
  dynamic deleted;
  dynamic deletedBy;
  bool? isActive;
  bool? isDeleted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['productId'] = productId;
    map['productCode'] = productCode;
    map['userName'] = userName;
    map['mobileNo'] = mobileNo;
    map['leadCode'] = leadCode;
    map['offerCompanyId'] = offerCompanyId;
    map['creditLimit'] = creditLimit;
    map['processingFee'] = processingFee;
    map['creditScore'] = creditScore;
    map['cibilReport'] = cibilReport;
    map['companyLeads'] = companyLeads;
    map['leadActivityMasterProgresses'] = leadActivityMasterProgresses;
    map['leadOffers'] = leadOffers;
    map['isAgreementAccept'] = isAgreementAccept;
    map['agreementDate'] = agreementDate;
    map['status'] = status;
    map['leadBankDetail'] = leadBankDetail;
    map['cityId'] = cityId;
    map['applicantName'] = applicantName;
    map['leadGenerator'] = leadGenerator;
    map['leadConverter'] = leadConverter;
    map['id'] = id;
    map['created'] = created;
    map['createdBy'] = createdBy;
    map['lastModified'] = lastModified;
    map['lastModifiedBy'] = lastModifiedBy;
    map['deleted'] = deleted;
    map['deletedBy'] = deletedBy;
    map['isActive'] = isActive;
    map['isDeleted'] = isDeleted;
    return map;
  }

}