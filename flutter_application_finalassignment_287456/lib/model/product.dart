class Product {
  String? productId;
  String? userId;
  String? productName;
  String? productType;
  String? productDesc;
  String? productPrice;
  String? productQty;
  String? productLat;
  String? productLong;
  String? productState;
  String? productLocality;
  String? productDate;

  Product(
      {this.productId,
      this.userId,
      this.productName,
      this.productType,
      this.productDesc,
      this.productPrice,
      this.productQty,
      this.productLat,
      this.productLong,
      this.productState,
      this.productLocality,
      this.productDate});

  Product.fromJson(Map<String?, dynamic> json) {
    productId = json['product_id'];
    userId = json['user_id'];
    productName = json['product_name'];
    productType = json['product_type'];
    productDesc = json['product_desc'];
    productPrice = json['product_price'];
    productQty = json['product_qty'];
    productLat = json['product_lat'];
    productLong = json['product_long'];
    productState = json['product_state'];
    productLocality = json['product_locality'];
    productDate = json['product_date'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['product_id'] = productId;
    data['user_id'] = userId;
    data['product_name'] = productName;
    data['product_type'] = productType;
    data['product_desc'] = productDesc;
    data['product_price'] = productPrice;
    data['product_qty'] = productQty;
    data['product_lat'] = productLat;
    data['product_long'] = productLong;
    data['product_state'] = productState;
    data['product_locality'] = productLocality;
    data['product_date'] = productDate;
    return data;
  }
}
