class Cart {
  String? cartId;
  String? productId;
  String? productName;
  String? productType;
  String? productDesc;
  String? productPrice;
  String? productQty;
  String? cartPrice;
  String? cartQty;
  String? userId;
  String? barteruserId;
  String? cartDate;

  Cart(
      {this.cartId,
      this.productId,
      this.productName,
      this.productType,
      this.productDesc,
      this.productPrice,
      this.productQty,
      this.cartPrice,
      this.cartQty,
      this.userId,
      this.barteruserId,
      this.cartDate});

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    productType = json['product_type'];
    productDesc = json['product_desc'];
    productPrice = json['product_price'];
    productQty = json['product_qty'];
    cartPrice = json['cart_price'];
    cartQty = json['cart_qty'];
    userId = json['user_id'];
    barteruserId = json['barteruser_id'];
    cartDate = json['cart_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_type'] = productType;
    data['product_desc'] = productDesc;
    data['product_price'] = productPrice;
    data['product_qty'] = productQty;
    data['cart_price'] = cartPrice;
    data['cart_qty'] = cartQty;
    data['user_id'] = userId;
    data['barteruser_id'] = barteruserId;
    data['cart_date'] = cartDate;
    return data;
  }
}
