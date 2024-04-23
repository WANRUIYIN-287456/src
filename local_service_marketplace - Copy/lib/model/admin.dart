class Admin {
  String? id;
  String? email;
  String? name;
  String? phone;
  String? password;

  Admin(
      {this.id,
      this.email,
      this.name,
      this.phone,
      this.password,});

  Admin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['password'] = password;
    return data;
  }
}