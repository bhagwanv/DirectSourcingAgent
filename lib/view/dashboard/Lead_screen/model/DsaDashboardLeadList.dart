class DsaDashboardLeadList {
  DsaDashboardLeadList({
      this.leadId, 
      this.status, 
      this.leadCode, 
      this.createdDate, 
      this.fullName, 
      this.mobileNo, 
      this.totalRecords, 
      this.profileImage,
      this.agentFullName,});

  DsaDashboardLeadList.fromJson(dynamic json) {
    leadId = json['leadId'];
    status = json['status'];
    leadCode = json['leadCode'];
    createdDate = json['createdDate'];
    fullName = json['fullName'];
    mobileNo = json['mobileNo'];
    totalRecords = json['totalRecords'];
    profileImage = json['profileImage'];
    agentFullName = json['agentFullName'];
  }
  int? leadId;
  String? status;
  String? leadCode;
  String? createdDate;
  String? fullName;
  String? mobileNo;
  int? totalRecords;
  String? profileImage;
  String? agentFullName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['leadId'] = leadId;
    map['status'] = status;
    map['leadCode'] = leadCode;
    map['createdDate'] = createdDate;
    map['fullName'] = fullName;
    map['mobileNo'] = mobileNo;
    map['totalRecords'] = totalRecords;
    map['profileImage'] = profileImage;
    map['agentFullName'] = agentFullName;
    return map;
  }

}