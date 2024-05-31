class Order {
  String? orderId;
  String? serviceId;
  String? userId;
  String? sellerId;
  String? serviceName;
  String? servicePrice;
  String? serviceUnit;
  String? orderQuantity;
  String? orderTotalprice;
  String? orderServicedate;
  String? orderServicetime;
  String? orderServiceaddress;
  String? orderMessage;
  String? orderDate;
  String? orderUserstatus;
  String? orderSellerstatus;
  String? orderStatus;
  String? paymentStatus;
  String? receiptId;

  Order(
      {this.orderId,
      this.serviceId,
      this.userId,
      this.sellerId,
      this.serviceName,
      this.servicePrice,
      this.serviceUnit,
      this.orderQuantity,
      this.orderTotalprice, 
      this.orderServicedate,
      this.orderServicetime,
      this.orderServiceaddress,
      this.orderMessage,
      this.orderDate,
      this.orderUserstatus,
      this.orderSellerstatus,
      this.orderStatus,
      this.paymentStatus,
      this.receiptId,
});

  Order.fromJson(Map<String?, dynamic> json) {
    orderId = json['order_id'];
    serviceId = json['service_id'];
    userId = json['user_id'];
    sellerId = json['seller_id'];
    serviceName = json['service_name'];
    servicePrice = json['service_price'];
    serviceUnit = json['service_unit'];
    orderQuantity = json['order_quantity'];
    orderTotalprice = json['order_totalprice'];
    orderServicedate = json['order_servicedate'];
    orderServicetime = json['order_servicetime'];
    orderServiceaddress = json['order_serviceaddress'];
    orderMessage = json['order_message'];
    orderDate = json['order_date'];
    orderUserstatus = json['order_userstatus'];
    orderSellerstatus = json['order_sellerstatus'];
    orderStatus = json['order_status'];
    paymentStatus = json['payment_status'];
    receiptId = json['receipt_id'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['order_id'] = orderId;
    data['service_id'] = serviceId;
    data['user_id'] = userId;
    data['seller_id'] = sellerId;
    data['service_name'] = serviceName;
    data['service_price'] = servicePrice;
    data['service_unit'] = serviceUnit;
    data['order_quantity'] = orderQuantity;
    data['order_totalprice'] = orderTotalprice;
    data['order_servicedate'] = orderServicedate;
    data['order_servicetime'] = orderServicetime;
    data['order_serviceaddress'] = orderServiceaddress;
    data['order_message'] = orderMessage;
    data['order_date'] = orderDate;
    data['order_userstatus'] = orderUserstatus;
    data['order_sellerstatus'] = orderSellerstatus;
    data['order_status'] = orderStatus;
    data['payment_status'] = paymentStatus;
    data['receipt_id'] = receiptId;
    return data;
  }
}
