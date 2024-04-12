class Seller {
  String? adminId;
  String? sellerId;
  String? uploadStatus;
  String? proStatus;
  String? preferredStatus;
  String? availableStatus;
  String? icName;
  String? certName;
  String? uploadDate;
  String? verifyStatus;
  String? token;

  Seller(
      {this.adminId,
      this.sellerId,
      this.uploadStatus,
      this.proStatus,
      this.preferredStatus,
      this.availableStatus,
      this.icName,
      this.certName,
      this.uploadDate,
      this.verifyStatus,
      this.token,
    });

  Seller.fromJson(Map<String?, dynamic> json) {
    adminId = json['admin_id'];
    sellerId = json['seller_id'];
    uploadStatus = json['upload_status'];
    proStatus = json['pro_status'];
    preferredStatus = json['preferred_status'];
    availableStatus = json['available_status'];
    icName = json['ic'];
    certName = json['cert'];
    uploadDate = json['upload_date'];
    verifyStatus = json['verify'];
    token = json['token'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['admin_id'] = adminId;
    data['seller_id'] = sellerId;
    data['upload_status'] = uploadStatus;
    data['pro_status'] = proStatus;
    data['preferred_status'] = preferredStatus;
    data['available_status'] = availableStatus;
    data['ic'] = icName;
    data['cert'] = certName;
    data['upload_date'] = uploadDate;
    data['verify'] = verifyStatus;
    data['token'] = token;
    return data;
  }
}