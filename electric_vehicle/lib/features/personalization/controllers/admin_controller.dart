import 'package:electric_vehicle/data/repositories/authentication/authentication_repository.dart';
import 'package:electric_vehicle/data/repositories/user/user_repository.dart';
import 'package:electric_vehicle/features/personalization/models/user/user_model.dart';
import 'package:electric_vehicle/features/personalization/screens/profile/widgets/re_authenticate_user_login_form.dart';
import 'package:electric_vehicle/utils/constants/image_strings.dart';
import 'package:electric_vehicle/utils/popups/full_screen_loader.dart';
import 'package:electric_vehicle/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../network_manager.dart';
import '../../../utils/constants/sizes.dart';
import '../../authentication/screens/login/admin/admin_login.dart';

class AdminController extends GetxController {
  static AdminController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final hidePassword = false.obs;
  final imageUploading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchAdminRecord();
  }

  // fetch user record
  Future<void> fetchAdminRecord() async {
    try{
      profileLoading.value = true;
      final user = await userRepository.fetchAdminDetails();
      this.user(user);
    } catch (e){
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  // save user record from any registration provider
  Future<void> saveAdminRecord(UserCredential? userCredentials) async {
    try {
      // first update the Rx user and then check if user data already stored.if not store new data
      await fetchAdminRecord();

      //if no record already stored
      if(user.value.id.isEmpty) {
        if (userCredentials != null) {
          //convert name to first and last name
          final nameParts = UserModel.nameParts(
              userCredentials.user!.displayName ?? '');
          final username = UserModel.generateUsername(
              userCredentials.user!.displayName ?? '');

          // Map Data
          final user = UserModel(
            id: userCredentials.user!.uid,
            firstName: nameParts[0],
            lastName: nameParts.length > 1
                ? nameParts.sublist(1).join(' ')
                : '',
            username: username,
            email: userCredentials.user!.email ?? '',
            phoneNumber: userCredentials.user!.phoneNumber ?? '',
            profilePicture: userCredentials.user!.photoURL ?? '',
          );

          // save user data
          await userRepository.saveAdminRecord(user);
        }
      }
    } catch (e) {
      EVLoaders.warningSnackBar(title: 'Data not save',
          message: 'Something went wrong while saving your information. You can re-save your data in your profile');
    }
  }

  /// delete account warning
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
        contentPadding: const EdgeInsets.all(EVSizes.md),
        title: 'Delete Account',
        middleText: 'Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently.',
        confirm: ElevatedButton(onPressed: () async => deleteAdminAccount(),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
          child: const Padding(padding: EdgeInsets.symmetric(horizontal: EVSizes.lg),
              child: Text('Delete')),
        ),
        cancel: OutlinedButton(onPressed: () => Navigator.of(Get.overlayContext!).pop(),
            child: const Text('Cancel'))
    );
  }

  /// delete user account
  void deleteAdminAccount() async {
    try{
      EVFullScreenLoader.openLoadingDialog('Processing', EVImages.docerAnimation);

      // first re authenticate user
      final auth = AuthenticationRepository.instance;
      final provider = auth.authUser!.providerData.map((e) => e.providerId).first;
      if(provider.isNotEmpty) {
        // re verify auth email
        if(provider == 'google.com'){
          await auth.signInWithGoogle();
          await auth.deleteAccountAdmin();
          EVFullScreenLoader.stopLoading();
          Get.offAll(() => const AdminLoginScreen());
        } else if(provider == 'password') {
          EVFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    }catch(e) {
      EVFullScreenLoader.stopLoading();
      EVLoaders.warningSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  /// re authenticate before deleting
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try{
      EVFullScreenLoader.openLoadingDialog('Processing', EVImages.docerAnimation);

      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        EVFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        EVFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthenticateWithEmailAndPassword(verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      EVFullScreenLoader.stopLoading();
      Get.offAll(() => const AdminLoginScreen());
    } catch(e){
      EVFullScreenLoader.stopLoading();
      EVLoaders.warningSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  /// upload profile image
  uploadAdminProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70, maxHeight: 512, maxWidth: 512);
      if(image != null){
        imageUploading.value = true;
        // upload image
        final imageUrl = await userRepository.uploadAdminImage('Users/Images/Admin/Profile/', image);

        // update user image record
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateAdminSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();

        EVLoaders.warningSnackBar(title: 'Congratulations', message: 'Your profile image has been uploaded!');
      }
    } catch (e) {
      EVLoaders.warningSnackBar(title: 'Oh Snap', message: 'Something went wrong: $e');
    }
    finally{
      imageUploading.value = false;
    }
  }

}