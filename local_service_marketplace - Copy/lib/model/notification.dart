class Notifications {
  String? notId;
  String? adminId;
  String? userId;
  String? notTitle;
  String? notBody;
  String? notDate;

  Notifications({
    this.notId,
    this.adminId,
    this.userId,
    this.notTitle,
    this.notBody,
    this.notDate,
  });

  Notifications.fromJson(Map<String?, dynamic> json) {
    notId = json['not_id'];
    adminId = json['admin_id'];
    userId = json['user_id'];
    notTitle = json['not_title'];
    notBody = json['not_body'];
    notDate = json['not_date'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['not_id'] = notId;
    data['admin_id'] = adminId;
    data['user_id'] = userId;
    data['not_title'] = notTitle;
    data['not_body'] = notBody;
    data['not_date'] = notDate;
    return data;
  }
}
