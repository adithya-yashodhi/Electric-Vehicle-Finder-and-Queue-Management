import 'package:cloud_firestore/cloud_firestore.dart';

class PortModel {
  final String id;
  final String portType;
  late final String noOfPort;
  final String capacity;
  late final String charge;
  final String speed;


  PortModel({
    required this.portType,
    required this.noOfPort,
    required this.capacity,
    required this.charge,
    required this.speed,
    required this.id,
  });

  static PortModel empty() =>
      PortModel(
        id: '',
        portType: '',
        noOfPort: '',
        capacity: '',
        charge: '',
        speed: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'PortType': portType,
      'NoOfPorts': noOfPort,
      'Capacity': capacity,
      'Price': charge,
      'ChargeSpeed': speed
    };
  }

  factory PortModel.fromMap(Map<String, dynamic> data) {
    return PortModel(
      id: data['Id'] as String,
      portType: data['PortType'] as String,
      noOfPort: data['NoOfPorts'] as String,
      capacity: data['Capacity'] as String,
      charge: data['Price'] as String,
      speed: data['ChargeSpeed'] as String,
    );
  }

  factory PortModel.fromDocumentSnapShot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return PortModel(
      id: snapshot.id,
      portType: data['PortType'] ?? '',
      noOfPort: data['NoOfPorts'] ?? '',
      capacity: data['Capacity'] ?? '',
      charge: data['Price'] ?? '',
      speed: data['ChargeSpeed'] ?? '',
    );
  }

}
