import 'dart:async';

import 'package:electric_vehicle/common/widgets/success_screen/success_screen.dart';
import 'package:electric_vehicle/utils/constants/text_strings.dart';
import 'package:electric_vehicle/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';

class AdminVerifyEmailController extends GetxController {
  static AdminVerifyEmailController get instance => Get.find();

  /// send email whenever verify screen appears & set timer for auto redirect
  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  /// send email verification link
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      EVLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Please check your inbox and verify your email.');
    } catch (e) {
      EVLoaders.errorSnackBar(title: 'oh Snap!', message: e.toString());
    }
  }

  ///  timer to automatically redirect on email verification
  setTimerForAutoRedirect() {
    Timer.periodic(
      const Duration(seconds: 1),
          (timer) async {
        await FirebaseAuth.instance.currentUser?.reload();
        final user = FirebaseAuth.instance.currentUser;
        if(user?.emailVerified ?? false){
          timer.cancel();
          Get.off(() => SuccessScreen(
            image: EVImages.successfullyRegisterAnimation,
            title: EVTexts.yourAccountCreatedTitle,
            subTitle: EVTexts.yourAccountCreatedSubTitle,
            onPressed: () => AuthenticationRepository.instance.adminScreenRedirect(),
          ),
          );
        }
      },
    );
  }

  ///   manually check if email verified
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified){
      Get.off(
            () => SuccessScreen(
          image: EVImages.successfullyRegisterAnimation,
          title: EVTexts.yourAccountCreatedTitle,
          subTitle: EVTexts.yourAccountCreatedSubTitle,
          onPressed: () => AuthenticationRepository.instance.adminScreenRedirect(),
        ),
      );
    }
  }
}
