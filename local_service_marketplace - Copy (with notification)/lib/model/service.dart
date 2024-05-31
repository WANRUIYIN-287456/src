class Service {
  String? serviceId;
  String? sellerId;
  String? serviceName;
  String? serviceCategory;
  String? serviceType;
  String? serviceDesc;
  String? servicePrice;
  String? serviceUnit;
  String? serviceLong;
  String? serviceLat;
  String? serviceState;
  String? serviceLocality;
  String? serviceDate;
  String? proStatus;
  String? preferredStatus;

  Service({
    this.serviceId,
    this.sellerId,
    this.serviceName,
    this.serviceCategory,
    this.serviceType,
    this.serviceDesc,
    this.servicePrice,
    this.serviceUnit,
    this.serviceLong,
    this.serviceLat,
    this.serviceState,
    this.serviceLocality,
    this.serviceDate,
    this.proStatus,
    this.preferredStatus,
  });

  Service.fromJson(Map<String?, dynamic> json) {
    serviceId = json['service_id'];
    sellerId = json['seller_id'];
    serviceName = json['service_name'];
    serviceCategory = json['service_category'];
    serviceType = json['service_type'];
    serviceDesc = json['service_desc'];
    servicePrice = json['service_price'];
    serviceUnit = json['service_unit'];
    serviceLong = json['service_long'];
    serviceLat = json['service_lat'];
    serviceState = json['service_state'];
    serviceLocality = json['service_locality'];
    serviceDate = json['service_date'];
    proStatus = json['pro_status'];
    preferredStatus = json['preferred_status'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['service_id'] = serviceId;
    data['seller_id'] = sellerId;
    data['service_name'] = serviceName;
    data['service_category'] = serviceCategory;
    data['service_type'] = serviceType;
    data['service_desc'] = serviceDesc;
    data['service_price'] = servicePrice;
    data['service_unit'] = serviceUnit;
    data['service_long'] = serviceLong;
    data['service_lat'] = serviceLat;
    data['service_state'] = serviceState;
    data['service_locality'] = serviceLocality;
    data['service_date'] = serviceDate;
    data['pro_status'] = proStatus;
    data['preferred_status'] = preferredStatus;
    return data;
  }
}
