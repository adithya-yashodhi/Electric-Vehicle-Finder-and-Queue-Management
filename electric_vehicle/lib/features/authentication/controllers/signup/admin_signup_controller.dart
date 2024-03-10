import 'package:electric_vehicle/data/repositories/authentication/authentication_repository.dart';
import 'package:electric_vehicle/data/repositories/user/user_repository.dart';
import 'package:electric_vehicle/features/authentication/screens/signup/verify_email.dart';
import 'package:electric_vehicle/utils/constants/image_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/controllers/admin_controller.dart';
import '../../../personalization/models/user/user_model.dart';

class AdminSignupController extends GetxController {

  static AdminSignupController get instance => Get.find();
  final adminController = Get.put(AdminController());

  /// variables
  final hidePassword = true.obs; // observable for hiding/showing password
  final privacyPolicy = true.obs;
  final email = TextEditingController(); // controller for email input
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> adminSignupFormKey = GlobalKey<FormState>(); // form key for form validation

  /// SIGNUP
  Future<void> adminSignup() async {
    try {
      // start loading
      EVFullScreenLoader.openLoadingDialog(
          'We are processing your information...', EVImages.docerAnimation);

      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EVFullScreenLoader.stopLoading();
        return;
      }
      //form validation
      if (!adminSignupFormKey.currentState!.validate()) {
        EVFullScreenLoader.stopLoading();
        return;
      }

      // privacy policy check
      if (!privacyPolicy.value) {
        EVLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message:
          'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use.',
        );
        return;
      }

      // register user in the firebase authentication & save user data in the firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
          email.text.trim(), password.text.trim());

      // save authenticated user data in the firebase firestore
      final newUser = UserModel(
          id: userCredential.user!.uid,
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          username: userName.text.trim(),
          email: email.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          profilePicture: '');

      final userRepository = Get.put(UserRepository());
      await userRepository.saveAdminRecord(newUser);

      // show success message
      EVLoaders.successSnackBar(title: 'Congratulations',
          message: 'Your account has been created! Verify email to continue.');

      // move to verify email screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim(),));
      // Get.to(() => const HomeScreen());
    } catch (e) {
      // remove loader
      EVFullScreenLoader.stopLoading();

      // show some generic error to the user
      EVLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}