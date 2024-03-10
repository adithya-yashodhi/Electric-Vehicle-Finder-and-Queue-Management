import 'package:electric_vehicle/data/repositories/user/user_repository.dart';
import 'package:electric_vehicle/features/personalization/screens/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../../network_manager.dart';
import '../../../../../../../utils/constants/image_strings.dart';
import '../../../../../../../utils/popups/full_screen_loader.dart';
import '../../../../../../../utils/popups/loaders.dart';
import '../../../../../controllers/admin_controller.dart';

class UpdateAdminNameController extends GetxController {
  UpdateAdminNameController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final adminController = AdminController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateAdminNameFormKey = GlobalKey<FormState>();

  /// init user dat when Home Screen appears
  @override
  void onInit() {
    initializeAdminNames();
    super.onInit();
  }

  ///fetch user record
  Future<void> initializeAdminNames() async {
    firstName.text = adminController.user.value.firstName;
    lastName.text = adminController.user.value.lastName;
  }

  Future<void> updateAdminName() async {
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
      if (!updateAdminNameFormKey.currentState!.validate()){
        EVFullScreenLoader.stopLoading();
        return;
      }

      // update user's first and last name in the firebase firestore
      Map<String, dynamic> name = {'FirstName' : firstName.text.trim(), 'LastName': lastName.text.trim()};
      await userRepository.updateAdminSingleField(name);

      // update the Rx user value
      adminController.user.value.firstName = firstName.text.trim();
      adminController.user.value.lastName = lastName.text.trim();

      // remove loader
      EVFullScreenLoader.stopLoading();

      // show success message
      EVLoaders.successSnackBar(title: 'Congratulations', message: 'Your name has been updated.');

      // move to previous screen
      Get.off(() => const ProfileScreen());
    } catch (e){
      EVFullScreenLoader.stopLoading();
      EVLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
