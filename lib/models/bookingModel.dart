import 'package:fixit/models/PartnerServiceModel.dart';

class BookingModel {
  int? id;
  String? name;
  String? description;
  String? phone;
  String? address;
  List<PartnerServiceModel> partnerServiceModel;

  BookingModel({this.id, this.name, this.description, this.phone, this.address, required this.partnerServiceModel});

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      phone: json['phone'],
      address: json['address'],
      partnerServiceModel: List<PartnerServiceModel>.from(json['partner_service'].map((x)=> PartnerServiceModel.fromJson(x)))
    );
  }
}
