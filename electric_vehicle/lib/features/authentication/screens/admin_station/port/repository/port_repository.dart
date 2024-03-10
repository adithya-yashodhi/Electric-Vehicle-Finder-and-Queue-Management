import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electric_vehicle/data/repositories/authentication/authentication_repository.dart';
import 'package:get/get.dart';
import '../../model/station_model.dart';
import '../port_detail/model/port_model.dart';

class PortRepository extends GetxController {
  static PortRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// function to save user data to firestore
  Future<void> savePortRecord(PortModel port, StationModel station) async {
    try {
      if (port.id.isEmpty) {
        throw 'Port ID is null or empty';
      }
      // Get the current authenticated user
      final authUser = AuthenticationRepository.instance.authUser;

      // Check if the user is authenticated
      if (authUser == null) {
        throw 'User is not authenticated';
      }

      // Construct the path to the station document based on admin ID and station ID
      final docPath =
          "Admin/${authUser.uid}/Stations/${station.id}/Ports/${port.id}";

      // Set the station data at the specified path
      await _db.doc(docPath).set(port.toJson());
    } catch (e) {
      throw 'Failed to save station record: $e';
    }
  }

  /// function to fetch user data based on user ID
  Future<List<PortModel>> fetchPortDetails(StationModel station) async {
    try {
      final authUser = AuthenticationRepository.instance.authUser;

      if (authUser == null) {
        throw 'User is not authenticated';
      }

      // Construct the path to the ports sub collection based on admin ID and station ID
      final collectionPath =
          "Admin/${authUser.uid}/Stations/${station.id}/Ports";

      final querySnapshot = await _db.collection(collectionPath).get();

      final List<PortModel> ports = [];

      for (var doc in querySnapshot.docs) {
        ports.add(PortModel.fromDocumentSnapShot(doc));
      }

      return ports;
    } catch (e) {
      throw 'Failed to fetch port details: $e';
    }
  }
}
