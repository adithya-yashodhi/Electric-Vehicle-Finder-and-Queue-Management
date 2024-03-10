import 'package:electric_vehicle/data/repositories/authentication/authentication_repository.dart';
import 'package:electric_vehicle/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../network_manager.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/controllers/user_controller.dart';

class AdminLoginController extends GetxController{
  // variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email =TextEditingController();
  final password =TextEditingController();
  GlobalKey<FormState> adminLoginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  @override
  void onInit() {
    rememberMe.value = localStorage.read('REMEMBER_ME') ?? false;
    email.text = rememberMe.value ? localStorage.read('REMEMBER_ME_EMAIL') ?? '' : '';
    password.text = rememberMe.value ? localStorage.read('REMEMBER_ME_PASSWORD') ?? '' : '';


    super.onInit();
  }

  // email and password sign-in
  Future<void> emailAndPasswordSignIn() async {
    try {
      // start loading
      EVFullScreenLoader.openLoadingDialog('Logging you in...', EVImages.docerAnimation);

      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EVFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if (!adminLoginFormKey.currentState!.validate()){
        EVFullScreenLoader.stopLoading();
        return;
      }

      localStorage.write('REMEMBER_ME', rememberMe.value);

      // save data if remember me is selected
      if(rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      } else {
        // clear stored email and password if remember me is not selected
        localStorage.remove('REMEMBER_ME_EMAIL');
        localStorage.remove('REMEMBER_ME_PASSWORD');
      }

      // login user using email and password authentication
      final userCredentials = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // remove loader
      EVFullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.adminScreenRedirect();
    }
    catch(e){
      EVFullScreenLoader.stopLoading();
      if (e is String) {
        EVLoaders.errorSnackBar(title: 'Oh Snap!', message: e);
      } else {
        EVLoaders.errorSnackBar(title: 'Oh Snap!', message: 'Something went wrong. Please try again.');
      }
    }
  }

  Future<void> googleSignIn() async {
    try{
      // start loading
      EVFullScreenLoader.openLoadingDialog('Logging you in...', EVImages.docerAnimation);

      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EVFullScreenLoader.stopLoading();
        return;
      }

      // google authentication
      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();

      // save user record
      await userController.saveUserRecord(userCredentials);

      // remove loader
      EVFullScreenLoader.stopLoading();

      // redirect
      AuthenticationRepository.instance.adminScreenRedirect();

    }catch(e){
      EVFullScreenLoader.stopLoading();
      EVLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}