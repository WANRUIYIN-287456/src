class Catch {
  String? catchId;
  String? catchName;
  String? catchDesc;
  String? catchType;
  String? catchPrice;
  String? catchQty;
  String? catchLat;
  String? catchLong;
  String? catchState;
  String? catchLocality;
  String? catchDate;

  Catch(
      {this.catchId,
      this.catchName,
      this.catchDesc,
      this.catchType,
      this.catchPrice,
      this.catchQty,
      this.catchLat,
      this.catchLong,
      this.catchState,
      this.catchLocality,
      this.catchDate});

  Catch.fromJson(Map<String?, dynamic> json) {
    catchId = json['catch_id'];
    catchName = json['catch_name'];
    catchDesc = json['catch_desc'];
    catchType = json['catch_type'];
    catchPrice = json['catch_price'];
    catchQty = json['catch_qty'];
    catchLat = json['catch_lat'];
    catchLong = json['catch_long'];
    catchState = json['catch_state'];
    catchLocality = json['catch_locality'];
    catchDate = json['catch_date'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['catch_id'] = catchId;
    data['catch_name'] = catchName;
    data['catch_desc'] = catchDesc;
    data['catch_type'] = catchType;
    data['catch_price'] = catchPrice;
    data['catch_qty'] = catchQty;
    data['catch_lat'] = catchLat;
    data['catch_long'] = catchLong;
    data['catch_state'] = catchState;
    data['catch_locality'] = catchLocality;
    data['catch_date'] = catchDate;
    return data;
  }
}
