class UserModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? role;
  String? address;

  UserModel({this.id, this.name, this.email, this.phone, this.role, this.address});

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    return new UserModel(
      id: json?['id'],
      name: json?['name'],
      email: json?['email'],
      address: json?['address']??"-",
      phone: json?['phone']??"-",
      role: json?['role'],
    );
  }
}
