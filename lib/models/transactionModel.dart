import 'package:fixit/models/PartnerServiceModel.dart';
import 'package:fixit/models/ServiceModel.dart';
import 'package:fixit/models/partnerModel.dart';
import 'package:fixit/models/userModel.dart';

class TransactionModel {
  int? id;
  DateTime? date;
  String? isAccepted;
  UserModel? user;
  PartnerModel? partner;
  ServiceModel? serviceModel;
  PartnerServiceModel? partnerServiceModel;

  TransactionModel({this.id, this.date, this.isAccepted, this.user, this.partner, this.partnerServiceModel, this.serviceModel});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      date: DateTime.parse(json['date']) ,
      isAccepted: json['is_accepted'],
      user: UserModel.fromJson(json['user']),
      partner: PartnerModel.fromJson(json['partner_service']?['partner']),
      partnerServiceModel: PartnerServiceModel.fromJson(json['partner_service']),
      serviceModel: ServiceModel.fromJson(json['partner_service']['service'])
    );
  }
}
