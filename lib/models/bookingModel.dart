class BookingModel {
  int? id;
  String? name;
  String? description;
  String? phone;
  String? address;

  BookingModel({this.id, this.name, this.description, this.phone, this.address});

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      phone: json['phone'],
      address: json['address'],
    );
  }
}
