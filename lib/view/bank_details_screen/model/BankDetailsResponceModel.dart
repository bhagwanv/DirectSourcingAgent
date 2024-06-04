
import 'BankDetailResult.dart';

class BankDetailsResponceModel {
  BankDetailsResult? result;
  bool? isSuccess;
  String? message;

  BankDetailsResponceModel({this.result, this.isSuccess, this.message});

  BankDetailsResponceModel.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new BankDetailsResult.fromJson(json['result']) : null;
    isSuccess = json['isSuccess'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    return data;
  }
}

class BankDetailsResult {
  List<BankDetailResult>? leadBankDetailDTOs;
  bool? isScaleUp;
  List<BankDocsModel>? bankDocs;

  BankDetailsResult({this.leadBankDetailDTOs, this.isScaleUp, this.bankDocs});

  BankDetailsResult.fromJson(Map<String, dynamic> json) {
    if (json['leadBankDetailDTOs'] != null) {
      leadBankDetailDTOs = <BankDetailResult>[];
      json['leadBankDetailDTOs'].forEach((v) {
        leadBankDetailDTOs!.add(new BankDetailResult.fromJson(v));
      });
    }
    isScaleUp = json['isScaleUp'];
    if (json['bankDocs'] != null) {
      bankDocs = <BankDocsModel>[];
      json['bankDocs'].forEach((v) {
        bankDocs!.add(new BankDocsModel.fromJson(v));
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


class BankDocsModel {
  String? documentType;
  String? documentName;
  String? fileURL;
  int? sequence;
  String? pdfPassword;
  String? documentNumber;

  BankDocsModel(
      {this.documentType,
        this.documentName,
        this.fileURL,
        this.sequence,
        this.pdfPassword,
        this.documentNumber});

  BankDocsModel.fromJson(Map<String, dynamic> json) {
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