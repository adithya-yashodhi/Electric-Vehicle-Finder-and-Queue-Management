import 'package:electric_vehicle/data/repositories/authentication/authentication_repository.dart';
import 'package:electric_vehicle/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:electric_vehicle/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../network_manager.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  //variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  // send reset password email
  sendPasswordResetEmail() async {
    try {
      // start loading
      EVFullScreenLoader.openLoadingDialog('Processing your request...', EVImages.docerAnimation);

      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EVFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        EVFullScreenLoader.stopLoading();
        return;
      }

      //send email to reset password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      // remove loader
      EVFullScreenLoader.stopLoading();

      // show success screen
      EVLoaders.successSnackBar(title: 'Email Sent', message: 'Email Link Sent to Reset your Password'.tr);

      // redirect
      Get.to(() => ResetPassword(email: email.text.trim()));

    } catch (e) {
      EVFullScreenLoader.stopLoading();
      EVLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      // start loading
      EVFullScreenLoader.openLoadingDialog('Processing your request...', EVImages.docerAnimation);

      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EVFullScreenLoader.stopLoading();
        return;
      }

      //send email to reset password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      // remove loader
      EVFullScreenLoader.stopLoading();

      // show success screen
      EVLoaders.successSnackBar(title: 'Email Sent', message: 'Email Link Sent to Reset your Password'.tr);

    } catch (e) {
      EVFullScreenLoader.stopLoading();
      EVLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}