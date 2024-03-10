import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electric_vehicle/data/repositories/authentication/authentication_repository.dart';
import 'package:get/get.dart';

import '../../../features/personalization/screens/vehicle/model/vehicle_model.dart';

class VehicleRepository extends GetxController {
  static VehicleRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<VehicleModel>> fetchUserVehicles() async {
    try{
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if(userId.isEmpty) throw 'Unable to find user information, Try again in few minutes.';

      final result = await _db.collection('Users').doc(userId).collection('Vehicles').get();
      return result.docs.map((documentSnapShot) => VehicleModel.fromDocumentSnapShot(documentSnapShot)).toList();

    }catch(e){
      throw 'Something went wrong while fetching Vehicle Information. Try again later.';
    }
  }

  Future<void> updateSelectedField(String vehicleId, bool selected) async {
    try{
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await _db.collection('Users').doc(userId).collection('Vehicles').doc(vehicleId).update(
          {'SelectedVehicle': selected});
    } catch(e){
      throw 'Unable to update your vehicle selection. Try again later';
    }
  }

  /// store new user vehicle
  Future<String> addVehicle(VehicleModel vehicle) async {
    try{
      final userId = AuthenticationRepository.instance.authUser!.uid;
      final currentVehicle = await _db.collection('Users').doc(userId).collection('Vehicles').add(vehicle.toJson());
      return currentVehicle.id;
    } catch(e){
      throw 'Something went wrong while saving vehicle information. Try again later';
    }
  }

}
