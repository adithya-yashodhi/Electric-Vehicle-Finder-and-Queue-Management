import 'package:electric_vehicle/data/repositories/user/user_repository.dart';
import 'package:electric_vehicle/features/personalization/screens/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../network_manager.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/controllers/user_controller.dart';

class UpdatePhoneNumberController extends GetxController {
  UpdatePhoneNumberController get instance => Get.find();

  final phoneNumber = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updatePhoneNumberFormKey = GlobalKey<FormState>();

  /// init user dat when Home Screen appears
  @override
  void onInit() {
    initializePhoneNumber();
    super.onInit();
  }

  ///fetch user record
  Future<void> initializePhoneNumber() async {
    phoneNumber.text = userController.user.value.phoneNumber;
  }

  Future<void> updatePhoneNumber() async {
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
      if (!updatePhoneNumberFormKey.currentState!.validate()){
        EVFullScreenLoader.stopLoading();
        return;
      }

      // update user's phone number in the firebase firestore
      final newPhoneNumber = phoneNumber.text.trim();
      await userRepository.updateSingleField({'PhoneNumber': newPhoneNumber});

      // update the Rx user value
      userController.user.value.phoneNumber = newPhoneNumber;

      // remove loader
      EVFullScreenLoader.stopLoading();

      // show success message
      EVLoaders.successSnackBar(title: 'Congratulations', message: 'Your phone number has been updated.');

      // move to previous screen
      Get.off(() => const ProfileScreen());
    } catch (e){
      EVFullScreenLoader.stopLoading();
      EVLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
