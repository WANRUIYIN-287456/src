class Cancel {
  String? orderId;
  String? userId;
  String? sellerId;
  String? cancelReason;
  String? cancelDate;

  Cancel(
      {this.orderId,
      this.userId,
      this.sellerId,
      this.cancelReason,
      this.cancelDate,
    });

 Cancel.fromJson(Map<String?, dynamic> json) {
    orderId = json['order_id'];
    userId = json['user_id'];
    sellerId = json['seller_id'];
    cancelReason = json['cancel_reason'];
    cancelDate = json['cancel_date'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['order_id'] = orderId;
    data['user_id'] = userId;
    data['seller_id'] = sellerId;
    data['cancel_reason'] = cancelReason;
    data['cancel_date'] = cancelDate;
    return data;
  }
}
