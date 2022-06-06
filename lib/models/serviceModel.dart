class ServiceModel {
  int? id;
  String? name;
 

  ServiceModel({this.id, this.name, });

  factory ServiceModel.fromJson(Map<String, dynamic>? json) {
    return ServiceModel(
      id: json?['id'],
      name: json?['name'],
    );
  }
}
