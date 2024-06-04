class LeadPanResponseModel {
  LeadPanResponseModel({
      this.panCard, 
      this.panImagePath, 
      this.documentId, 
      this.fatherName, 
      this.dob, 
      this.nameOnCard,});

  LeadPanResponseModel.fromJson(dynamic json) {
    panCard = json['panCard'];
    panImagePath = json['panImagePath'];
    documentId = json['documentId'];
    fatherName = json['fatherName'];
    dob = json['dob'];
    nameOnCard = json['nameOnCard'];
  }
  String? panCard="";
  String? panImagePath="";
  int? documentId=0;
  String? fatherName="";
  String? dob="";
  String? nameOnCard="";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['panCard'] = panCard;
    map['panImagePath'] = panImagePath;
    map['documentId'] = documentId;
    map['fatherName'] = fatherName;
    map['dob'] = dob;
    map['nameOnCard'] = nameOnCard;
    return map;
  }

}