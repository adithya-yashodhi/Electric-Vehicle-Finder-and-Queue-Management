import 'package:electric_vehicle/data/repositories/user/user_repository.dart';
import 'package:electric_vehicle/features/personalization/screens/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../../network_manager.dart';
import '../../../../../../../utils/constants/image_strings.dart';
import '../../../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../../../utils/popups/loaders.dart';
import '../../../../../controllers/admin_controller.dart';

class UpdateAdminEmailController extends GetxController {
  UpdateAdminEmailController get instance => Get.find();

  final adminEmail = TextEditingController();
  final adminController = AdminController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateAdminEmailFormKey = GlobalKey<FormState>();

  /// init user dat when Home Screen appears
  @override
  void onInit() {
    initializeAdminEmail();
    super.onInit();
  }

  ///fetch user record
  Future<void> initializeAdminEmail() async {
    adminEmail.text = adminController.user.value.email;
  }

  Future<void> updateAdminEmail() async {
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
      if (!updateAdminEmailFormKey.currentState!.validate()){
        EVFullScreenLoader.stopLoading();
        return;
      }

      // update user's phone number in the firebase firestore
      final newAdminEmail = adminEmail.text.trim();
      await userRepository.updateAdminSingleField({'Email': newAdminEmail});

      // update the Rx user value
      adminController.user.value.email = newAdminEmail;

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
