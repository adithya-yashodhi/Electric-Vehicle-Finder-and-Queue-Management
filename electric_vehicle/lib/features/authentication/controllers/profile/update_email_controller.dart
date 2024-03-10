import 'package:electric_vehicle/data/repositories/user/user_repository.dart';
import 'package:electric_vehicle/features/personalization/screens/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../network_manager.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/controllers/user_controller.dart';

class UpdateEmailController extends GetxController {
  UpdateEmailController get instance => Get.find();

  final email = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateEmailFormKey = GlobalKey<FormState>();

  /// init user dat when Home Screen appears
  @override
  void onInit() {
    initializeEmail();
    super.onInit();
  }

  ///fetch user record
  Future<void> initializeEmail() async {
    email.text = userController.user.value.email;
  }

  Future<void> updateEmail() async {
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
      if (!updateEmailFormKey.currentState!.validate()){
        EVFullScreenLoader.stopLoading();
        return;
      }

      // update user's phone number in the firebase firestore
      final newEmail = email.text.trim();
      await userRepository.updateSingleField({'Email': newEmail});

      // update the Rx user value
      userController.user.value.email = newEmail;

      // remove loader
      EVFullScreenLoader.stopLoading();

      // show success message
      EVLoaders.successSnackBar(title: 'Congratulations', message: 'Your Email has been updated.');

      // move to previous screen
      Get.off(() => const ProfileScreen());
    } catch (e){
      EVFullScreenLoader.stopLoading();
      EVLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
