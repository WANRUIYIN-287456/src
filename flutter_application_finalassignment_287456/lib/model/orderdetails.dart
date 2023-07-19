class OrderDetails {
  String? orderId;
  String? productId;
  String? barteruserId;
  String? userId;
  String? orderDate;
  String? orderQty;
  String? orderStatus;
  String? barterorderId;
  String? barterproductId;
  String? barterproductName;
  String? barterOrderStatus;
  String? paymentorderId;
  String? paymentAmount;
  String? paymentOrderStatus;
  String? productName;
  String? productType;
  String? productDesc;
  String? productPrice;
  String? productQty;
  String? productState;
  String? productLocality;
  String? productDate;
  String? productOption;
  String? productStatus;

  OrderDetails(
      {this.orderId,
      this.productId,
      this.barteruserId,
      this.userId,
      this.orderDate,
      this.orderQty,
      this.orderStatus,
      this.barterorderId,   
      this.barterproductId,
      this.barterproductName,    
      this.barterOrderStatus,
      this.paymentorderId,      
      this.paymentAmount,  
      this.paymentOrderStatus, 
      this.productName,
      this.productType,
      this.productDesc,
      this.productPrice,
      this.productQty,
      this.productState,
      this.productLocality,
      this.productDate,
      this.productOption,
      this.productStatus});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    productId = json['product_id'];
    barteruserId = json['barteruser_id'];
    userId = json['user_id'];
    orderDate = json['order_date'];
    orderQty = json['order_qty'];
    orderStatus = json['order_status'];
    barterorderId = json['barterorder_id'];
    barterproductId = json['barterproduct_id'];
    barterproductName = json['barterproduct_name'];
    barterOrderStatus = json['barterorder_status'];
    paymentorderId = json['paymentorder_id'];
    paymentAmount = json['payment_amount'];
    paymentOrderStatus = json['paymentorder_status'];
    productName = json['product_name'];
    productType = json['product_type'];
    productDesc = json['product_desc'];
    productPrice = json['product_price'];
    productQty = json['product_qty'];
    productState = json['product_state'];
    productLocality = json['product_locality'];
    productDate = json['product_date'];
    productOption = json['product_option'];
    productStatus = json['product_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['barteruser_id'] = barteruserId;
    data['user_id'] = userId;
    data['order_date'] = orderDate;
    data['order_qty'] = orderQty;
    data['order_status'] = orderStatus;
    data['barterorder_id'] = barterorderId;
    data['barterproduct_id'] = barterproductId;
    data['barterproduct_name'] = barterproductName;
    data['barterorder_status'] = barterOrderStatus;
    data['paymentorder_id'] = paymentorderId;
    data['payment_amount'] = paymentAmount;
    data['paymentorder_status'] = paymentOrderStatus;
    data['product_name'] = productName;
    data['product_type'] = productType;
    data['product_desc'] = productDesc;
    data['product_price'] = productPrice;
    data['product_qty'] = productQty;
    data['product_state'] = productState;
    data['product_locality'] = productLocality;
    data['product_date'] = productDate;
    data['product_option'] = productOption;
    data['product_status'] = productStatus;
    return data;
  }
}
