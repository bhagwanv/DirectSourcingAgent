class SaveBankDetailsRequestModel {
  List<LeadBankDetailDTOs>? leadBankDetailDTOs;
  bool? isScaleUp;
  List<BankDocs>? bankDocs;

  SaveBankDetailsRequestModel(
      {this.leadBankDetailDTOs, this.isScaleUp, this.bankDocs});

  SaveBankDetailsRequestModel.fromJson(Map<String, dynamic> json) {
    if (json['leadBankDetailDTOs'] != null) {
      leadBankDetailDTOs = <LeadBankDetailDTOs>[];
      json['leadBankDetailDTOs'].forEach((v) {
        leadBankDetailDTOs!.add(new LeadBankDetailDTOs.fromJson(v));
      });
    }
    isScaleUp = json['isScaleUp'];
    if (json['bankDocs'] != null) {
      bankDocs = <BankDocs>[];
      json['bankDocs'].forEach((v) {
        bankDocs!.add(new BankDocs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.leadBankDetailDTOs != null) {
      data['leadBankDetailDTOs'] =
          this.leadBankDetailDTOs!.map((v) => v.toJson()).toList();
    }
    data['isScaleUp'] = this.isScaleUp;
    if (this.bankDocs != null) {
      data['bankDocs'] = this.bankDocs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeadBankDetailDTOs {
  int? leadId;
  String? Type;
  String? bankName;
  String? ifscCode;
  String? accountType;
  int? activityId;
  int? subActivityId;
  String? accountNumber;
  String? accountHolderName;
  String? pdfPassword;
  String? surrogateType;

  LeadBankDetailDTOs(
      {this.leadId,
        this.Type,
        this.bankName,
        this.ifscCode,
        this.accountType,
        this.activityId,
        this.subActivityId,
        this.accountNumber,
        this.accountHolderName,
        this.pdfPassword,
        this.surrogateType});

  LeadBankDetailDTOs.fromJson(Map<String, dynamic> json) {
    leadId = json['leadId'];
    Type = json['Type'];
    bankName = json['bankName'];
    ifscCode = json['ifscCode'];
    accountType = json['accountType'];
    activityId = json['activityId'];
    subActivityId = json['subActivityId'];
    accountNumber = json['accountNumber'];
    accountHolderName = json['accountHolderName'];
    pdfPassword = json['pdfPassword'];
    surrogateType = json['surrogateType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leadId'] = this.leadId;
    data['Type'] = this.Type;
    data['bankName'] = this.bankName;
    data['ifscCode'] = this.ifscCode;
    data['accountType'] = this.accountType;
    data['activityId'] = this.activityId;
    data['subActivityId'] = this.subActivityId;
    data['accountNumber'] = this.accountNumber;
    data['accountHolderName'] = this.accountHolderName;
    data['pdfPassword'] = this.pdfPassword;
    data['surrogateType'] = this.surrogateType;
    return data;
  }
}

class BankDocs {
  String? documentType;
  String? documentName;
  String? fileURL;
  int? sequence;
  String? pdfPassword;
  String? documentNumber;

  BankDocs(
      {this.documentType,
        this.documentName,
        this.fileURL,
        this.sequence,
        this.pdfPassword,
        this.documentNumber});

  BankDocs.fromJson(Map<String, dynamic> json) {
    documentType = json['documentType'];
    documentName = json['documentName'];
    fileURL = json['fileURL'];
    sequence = json['sequence'];
    pdfPassword = json['pdfPassword'];
    documentNumber = json['documentNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['documentType'] = this.documentType;
    data['documentName'] = this.documentName;
    data['fileURL'] = this.fileURL;
    data['sequence'] = this.sequence;
    data['pdfPassword'] = this.pdfPassword;
    data['documentNumber'] = this.documentNumber;
    return data;
  }
}