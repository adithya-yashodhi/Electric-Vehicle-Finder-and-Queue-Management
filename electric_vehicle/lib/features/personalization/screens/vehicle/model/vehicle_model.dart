import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleModel {
  String id;
  final String vehicleModel;
  final String vehicleNumber;
  final String batteryCapacity;
  final String portType;
  final String chargingPower;
  final String fastChargingSupport;
  bool selectedVehicle;

  VehicleModel({
    required this.id,
    required this.vehicleModel,
    required this.vehicleNumber,
    required this.batteryCapacity,
    required this.portType,
    required this.chargingPower,
    required this.fastChargingSupport,
    this.selectedVehicle = true,
  });

  static VehicleModel empty() => VehicleModel(
    id: '',
    vehicleModel: '',
    vehicleNumber: '',
    batteryCapacity: '',
    portType: '',
    chargingPower: '',
    fastChargingSupport: '',
  );

  Map<String, dynamic> toJson() {
    return {
      //'Id': id,
      'VehicleModel': vehicleModel,
      'VehicleNumber': vehicleNumber,
      'BatteryCapacity': batteryCapacity,
      'PortType': portType,
      'ChargingPower': chargingPower,
      'FastChargingSupport': fastChargingSupport,
      'SelectedVehicle': selectedVehicle,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> data) {
      return VehicleModel(
        id: data['Id'] as String,
        vehicleModel: data['VehicleModel'] as String,
        vehicleNumber: data['VehicleNumber'] as String,
        batteryCapacity: data['BatteryCapacity'] as String,
        portType: data['PortType'] as String,
        chargingPower: data['ChargingPower'] as String,
        fastChargingSupport: data['FastChargingSupport'] as String,
        selectedVehicle: data['SelectedVehicle'] as bool,
      );
  }

  // factory constructor to create an station model from a documentSnapShot
  factory VehicleModel.fromDocumentSnapShot(DocumentSnapshot snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;

      return VehicleModel(
        id: snapshot.id,
        vehicleModel: data['VehicleModel'] ?? '',
        vehicleNumber: data['VehicleNumber'] ?? '',
        batteryCapacity: data['BatteryCapacity'] ?? '',
        portType: data['PortType'] ?? '',
        chargingPower: data['ChargingPower'] ?? '',
        fastChargingSupport: data['FastChargingSupport'] ?? '',

      );
  }
}
