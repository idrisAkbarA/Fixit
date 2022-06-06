class PartnerModel {
  int? id;
  String? name;
  String? description;
  String? phone;
  String? address;

  PartnerModel({this.id, this.name, this.description, this.phone, this.address});

  factory PartnerModel.fromJson(Map<String, dynamic>? json) {
    return PartnerModel(
      id: json?['id'],
      name: json?['name'],
      description: json?['description'],
      phone: json?['phone'],
      address: json?['address'],
    );
  }
}
