import 'package:electric_vehicle/data/repositories/user/user_repository.dart';
import 'package:electric_vehicle/features/authentication/screens/admin_station/station_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../../network_manager.dart';
import '../../../../../../../utils/constants/image_strings.dart';
import '../../../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../../../utils/popups/loaders.dart';
import '../../port/controller/port_controller.dart';

class UpdatePortDetailController extends GetxController {
  UpdatePortDetailController get instance => Get.find();

  final noOfPorts = TextEditingController();
  final charge = TextEditingController();
  final portController = PortController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updatePortDetailFormKey = GlobalKey<FormState>();

  /// init user dat when Home Screen appears
  @override
  void onInit() {
    initializePortDetail();
    super.onInit();
  }

  ///fetch user record
  Future<void> initializePortDetail() async {
    noOfPorts.text = portController.port.value.noOfPort;
    charge.text = portController.port.value.charge;
  }

  Future<void> updatePortInfo() async {
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
      if (!updatePortDetailFormKey.currentState!.validate()){
        EVFullScreenLoader.stopLoading();
        return;
      }

      // update user's phone number in the firebase firestore
      final newPortCount = noOfPorts.text.trim();
      await userRepository.updatePortData({'NoOfPorts': newPortCount});
      final newAmount = charge.text.trim();
      await userRepository.updatePortData({'Price': newAmount});


      // update the Rx user value
      portController.port.value.noOfPort = newPortCount;
      portController.port.value.charge = newAmount;

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
