class OrderPay {
  String? paymentorderId;
  String? orderId;
  String? productId;
  String? productName;
  String? paymentAmount;
  String? paymentOrderStatus;

  OrderPay(
      {this.paymentorderId,
      this.orderId,
      this.productId,
      this.productName,       
      this.paymentAmount,  
      this.paymentOrderStatus, 
      });

  OrderPay.fromJson(Map<String, dynamic> json) {
    paymentorderId = json['paymentorder_id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    paymentAmount = json['payment_amount'];
    paymentOrderStatus = json['paymentorder_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentorder_id'] = paymentorderId;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['payment_amount'] = paymentAmount;
    data['paymentorder_status'] = paymentOrderStatus;
    return data;
  }
}