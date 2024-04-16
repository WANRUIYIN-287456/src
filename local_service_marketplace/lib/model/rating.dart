class Rating {
  String? orderId;
  String? userId;
  String? sellerId;
  String? rating;
  String? review;
  String? ratingStatus;
  String? ratingDate;
  String? serviceName;
  String? userName;

  Rating({
    this.orderId,
    this.userId,
    this.sellerId,
    this.rating,
    this.review,
    this.ratingStatus,
    this.ratingDate,
    this.serviceName,
    this.userName,
  });

  Rating.fromJson(Map<String?, dynamic> json) {
    orderId = json['order_id'];
    userId = json['user_id'];
    sellerId = json['seller_id'];
    rating = json['rating'];
    review = json['review'];
    ratingStatus = json['rating_status'];
    ratingDate = json['rating_date'];
    serviceName = json['service_name'];
    userName = json['user_name'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['order_id'] = orderId;
    data['user_id'] = userId;
    data['seller_id'] = sellerId;
    data['rating'] = rating;
    data['review'] = review;
    data['rating_status'] = ratingStatus;
    data['rating_date'] = ratingDate;
    data['service_name'] = serviceName;
    data['user_name'] = userName;
    return data;
  }
}
