class Order {
  String? orderId;
  // String? orderBill;
  String? productId;
  // String? orderPaid;
  String? barteruserId;
  String? userId;
  String? orderDate;
  String? orderQty;
  String? orderStatus;
  // String? orderLat;
  // String? orderLng;

  Order(
      {this.orderId,
      // this.orderBill,
      // this.orderPaid,
      this.barteruserId,
      this.userId,
      this.orderDate,
      this.orderStatus,
      this.orderQty
      // this.orderLat,
      // this.orderLng
      });

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    // orderBill = json['order_bill'];
    // orderPaid = json['order_paid'];
    barteruserId = json['barteruser_id'];
    userId = json['user_id'];
    orderDate = json['order_date'];
    orderStatus = json['order_status'];
    orderQty = json['order_qty'];
    // orderLat = json['order_lat'];
    // orderLng = json['order_lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    // data['order_bill'] = orderBill;
    // data['order_paid'] = orderPaid;
    data['barteruser_id'] = barteruserId;
    data['user_id'] = userId;
    data['order_date'] = orderDate;
    data['order_status'] = orderStatus;
    data['order_qty'] = orderQty;
    // data['order_lat'] = orderLat;
    // data['order_lng'] = orderLng;
    return data;
  }
}