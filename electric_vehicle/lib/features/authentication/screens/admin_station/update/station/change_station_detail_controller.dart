import 'package:electric_vehicle/data/repositories/user/user_repository.dart';
import 'package:electric_vehicle/features/authentication/screens/admin_station/station_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../../network_manager.dart';
import '../../../../../../../utils/constants/image_strings.dart';
import '../../../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../../../utils/popups/loaders.dart';
import '../../controller/station_controller.dart';

class UpdateStationDetailController extends GetxController {
  UpdateStationDetailController get instance => Get.find();

  final description = TextEditingController();
  final phoneNo = TextEditingController();
  final address = TextEditingController();
  final stationController = StationController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateStationDetailFormKey = GlobalKey<FormState>();

  /// init user dat when Home Screen appears
  @override
  void onInit() {
    initializeStationDetail();
    super.onInit();
  }

  ///fetch user record
  Future<void> initializeStationDetail() async {
    description.text = stationController.station.value.description;
    phoneNo.text = stationController.station.value.stationPhoneNumber;
    address.text = stationController.station.value.stationAddress;
  }

  Future<void> updateStationInfo() async {
    try{
      // start loading
      EVFullScreenLoader.openLoadingDialog('We are updating your information...', EVImages.docerAnimation);

      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EVFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if (!updateStationDetailFormKey.currentState!.validate()){
        EVFullScreenLoader.stopLoading();
        return;
      }

      // update user's phone number in the firebase firestore
      final newDescription = description.text.trim();
      await userRepository.updateStationData({'Description': newDescription});
      final newPhoneNumber = description.text.trim();
      await userRepository.updateStationData({'PhoneNumber': newPhoneNumber});
      final newAddress = description.text.trim();
      await userRepository.updateStationData({'StationAddress': newAddress});

      // update the Rx user value
      stationController.station.value.description = newDescription;
      stationController.station.value.stationPhoneNumber = newPhoneNumber;
      stationController.station.value.stationAddress = newAddress;

      // remove loader
      EVFullScreenLoader.stopLoading();

      // show success message
      EVLoaders.successSnackBar(title: 'Congratulations', message: 'Your phone number has been updated.');

      // move to previous screen
      Get.off(() => const StationInformationScreen());
    } catch (e){
      EVFullScreenLoader.stopLoading();
      EVLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
