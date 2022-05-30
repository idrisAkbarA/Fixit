class UserModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? role;

  UserModel({this.id, this.name, this.email, this.phone, this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return new UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
    );
  }
}
