import 'package:fixit/models/serviceModel.dart';

class PartnerOrderModel {
  int? id;
  DateTime? date;
  String? location;
  String? latitude;
  String? longtitude;
  String? note;
  String? isAccepted;
  bool? isPaid;
  int? userId;
  int? partnerId;
  int? serviceId;
  int? price;
  String? partnerName;
  int? transactionId;
  String? serviceName;
  String? customerName;
  String? description;
  String? phone;
  String? address;
  ServiceModel? service;

  PartnerOrderModel(
      {this.id,
      this.date,
      this.location,
      this.latitude,
      this.longtitude,
      this.note,
      this.isAccepted,
      this.isPaid,
      this.userId,
      this.partnerId,
      this.serviceId,
      this.price,
      this.partnerName,
      this.transactionId,
      this.serviceName,
      this.customerName,
      this.description,
      this.phone,
      this.address,
      this.service
      });

  factory PartnerOrderModel.fromJson(Map<String, dynamic>? json) {
    return PartnerOrderModel(
      id: json?["id"],
      date: DateTime.parse(json?["date"]) ,
      location: json?["location"],
      latitude: json?["latitude"],
      longtitude: json?["longtitude"],
      note: json?["note"],
      isAccepted: json?["is_accepted"],
      isPaid: json?["is_paid"] == 1? true: false,
      userId: json?["user_id"],
      partnerId: json?["partner_id"],
      serviceId: json?["service_id"],
      price: json?["price"],
      partnerName: json?["partner_name"],
      serviceName: json?["service_name"],
      customerName: json?["customer_name"],
      transactionId: json?["transaction_id"],
      description: json?["description"],
      phone: json?["phone"],
      address: json?["address"],
      service: ServiceModel.fromJson(json?["partner_service"]["service"])
    );
  }
}
