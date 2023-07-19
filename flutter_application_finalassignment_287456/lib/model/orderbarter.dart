class OrderBarter {
  String? barterorderId;
  String? orderId;
  String? productId;
  String? barterproductId;
  String? barterOrderStatus;

  OrderBarter(
      {this.barterorderId,
      this.orderId,
      this.productId,      
      this.barterproductId,   
      this.barterOrderStatus,
      });

  OrderBarter.fromJson(Map<String, dynamic> json) {
    barterorderId = json['barterorder_id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    barterproductId = json['barterproduct_id'];
    barterOrderStatus = json['barterorder_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['barterorder_id'] = barterorderId;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['barterproduct_id'] = barterproductId;
    data['barterorder_status'] = barterOrderStatus;
    return data;
  }
}