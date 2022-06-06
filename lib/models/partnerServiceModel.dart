import 'package:fixit/models/serviceModel.dart';

class PartnerServiceModel {
  int? id;
  String? price;
  int? partnerId;
  ServiceModel? service;

  PartnerServiceModel({required this.id, required this.price, required this.partnerId, required this.service});

  factory PartnerServiceModel.fromJson(Map<String, dynamic>? json) {
    return PartnerServiceModel(
      id: json?['id'],
      price: json?['price'],
      partnerId: json?['partner_id'],
      service: ServiceModel.fromJson(json?['service']),
    );
  }
}
