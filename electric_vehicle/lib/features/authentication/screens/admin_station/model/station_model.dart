import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electric_vehicle/utils/formatters/formatter.dart';

class StationModel {
  String id;
  final String stationName;
  final String registerNumber;
  late final String description;
  late final String stationPhoneNumber;
  late final String stationAddress;
  final String longitude;
  final String latitude;
  late final String profilePicture;
  final bool isOpen24Hours;

  StationModel({
    required this.id,
    required this.stationName,
    required this.registerNumber,
    required this.description,
    required this.stationPhoneNumber,
    required this.stationAddress,
    required this.longitude,
    required this.latitude,
    required this.profilePicture,
    required this.isOpen24Hours,
  });

  String get formattedPhoneNo =>
      EVFormatter.formatPhoneNumber(stationPhoneNumber);

  static StationModel empty() => StationModel(
        id: '',
        stationName: '',
        registerNumber: '',
        description: '',
        stationPhoneNumber: '',
        stationAddress: '',
        longitude: '',
        latitude: '',
        profilePicture: '',
        isOpen24Hours: false,
      );

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'StationName': stationName,
      'RegisterNumber': registerNumber,
      'Description': description,
      'PhoneNumber': stationPhoneNumber,
      'StationAddress': stationAddress,
      'Longitude': longitude,
      'Latitude': latitude,
      'ProfilePicture' : profilePicture,
      'isOpen24Hours': isOpen24Hours,

    };
  }

  // factory StationModel.fromMap(Map<String, dynamic> data) {
  //   return StationModel(
  //     id: data['Id'] as String,
  //     stationName: data['StationName'] as String,
  //     registerNumber: data['RegisterNumber'] as String,
  //     description: data['Description'] as String,
  //     stationPhoneNumber: data['PhoneNumber'] as String,
  //     stationAddress: data['StationAddress'] as String,
  //     longitude: data['Longitude'] as String,
  //     latitude: data['Latitude'] as String,
  //     profilePicture: data['ProfilePicture']  as String,
  //     isOpen24Hours: data['isOpen24Hours'] as bool,
  //   );
  // }

  // factory constructor to create an station model from a documentSnapShot
  factory StationModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null){
      final data = document.data()!;
      return StationModel (
      id: document.id,
      stationName: data['StationName'] ?? '',
      registerNumber: data['RegisterNumber'] ?? '',
      description: data['Description'] ?? '',
      stationPhoneNumber: data['PhoneNumber'] ?? '',
      stationAddress: data['StationAddress'] ?? '',
      longitude: data['Longitude'] ?? '',
      latitude: data['Latitude'] ?? '',
      profilePicture: data['ProfilePicture'] ?? '',
      isOpen24Hours: data['isOpen24Hours'] ?? false,
    );
    } else {
      return StationModel.empty();
    }
  }

}
