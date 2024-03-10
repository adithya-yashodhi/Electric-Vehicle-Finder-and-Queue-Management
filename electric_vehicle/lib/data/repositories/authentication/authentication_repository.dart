import 'package:electric_vehicle/features/authentication/screens/login/user/login.dart';
import 'package:electric_vehicle/features/authentication/screens/signup/verify_email.dart';
import 'package:electric_vehicle/navigation_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../admin_navigation_menu.dart';
import '../../../features/authentication/screens/login/admin/admin_login.dart';
import '../../../features/authentication/screens/onboarding/onboarding.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../user/user_repository.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  /// get authenticated user data
  User? get authUser => _auth.currentUser;

  ///called from main.dart on app launch
  @override
  void onReady() {
    // remove the native splash screen
    FlutterNativeSplash.remove();
    // redirect to the appropriate screen
    screenRedirect();
  }

  ///Function to show relevant screen
  screenRedirect() async {
    final user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        Get.offAll(() => const NavigationMenu());
      } else {
        Get.offAll(() => VerifyEmailScreen(
              email: _auth.currentUser?.email,
            ));
      }
    } else {
      // Local storage
      deviceStorage.writeIfNull('IsFirstTime', true);
      //check if it's the first time launching the app
      deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(() =>
              const LoginScreen()) // redirect to the login screen if not the first time
          : Get.offAll(
              const OnBoardingScreen()); // redirect to onboarding screen if it's first time
    }
  }

  adminScreenRedirect() async {
    final user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        Get.offAll(() => const AdminNavigationMenu());
      } else {
        Get.offAll(() => VerifyEmailScreen(
          email: _auth.currentUser?.email,
        ));
      }
    } else {
      // Local storage
      deviceStorage.writeIfNull('IsFirstTime', true);
      //check if it's the first time launching the app
      deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(() =>
      const AdminLoginScreen()) // redirect to the login screen if not the first time
          : Get.offAll(
          const OnBoardingScreen()); // redirect to onboarding screen if it's first time
    }
  }

  // if(kDebugMode) {
  //   print('======================= GET STORAGE Auth Repo=================');
  //   print(deviceStorage.read('IsFirstTime'));
  // }

  /* ---------------------------------- Email & Password sign-in ------------------------------*/

  /// [emailAuthentication] - signIn
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseException catch (e) {
      if (e.code == 'network-request-failed') {
        throw 'A network error has occurred. Please check your internet connection and try again.';
      } else {
        throw 'Invalid Email or Password. Please Check and try again.';
      }
    } on FormatException catch (_) {
      throw 'Invalid Email or Password. Please Check and try again.';
    } on PlatformException catch (e) {
      throw 'Platform Exception: ${e.message}. Please try again later.';
    } on Exception catch (e) {
      throw 'Something went wrong: $e';
    }
  }

  /// [emailAuthentication] - REGISTER
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw EVFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EVFormatException();
    } on PlatformException catch (e) {
      throw EVPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [emailVerification] - MAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw EVFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EVFormatException();
    } on PlatformException catch (e) {
      throw EVPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [ReAuthenticate] - ReAuthenticate User
  Future<void> reAuthenticateWithEmailAndPassword(String email, String password) async {
    try {
      // create a credential
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

      //reAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw EVFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EVFormatException();
    } on PlatformException catch (e) {
      throw EVPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [EmailAuthentication] - forget password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw EVFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EVFormatException();
    } on PlatformException catch (e) {
      throw EVPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

/* ---------------------------------- Federate identity & social sign-in ------------------------------*/

  /// [GoogleAuthentication] - GOOGLE
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      // obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await userAccount?.authentication;

      //create a new credential
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
      );

      // once signed in, return the UserCredential
      return await _auth.signInWithCredential(credentials);

    } on FirebaseAuthException catch (e) {
      throw EVFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw EVFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EVFormatException();
    } on PlatformException catch (e) {
      throw EVPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Something went wrong: $e');
      return null;
    }
  }

  /// [FacebookAuthentication] - FACEBOOK

/* ---------------------------------- ./end Federate identity & social sign-in------------------------------*/

  /// [LogoutUser] - valid for any authentication
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw EVFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EVFormatException();
    } on PlatformException catch (e) {
      throw EVPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// DeleteUser -remove user auth and firebase account
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw EVFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EVFormatException();
    } on PlatformException catch (e) {
      throw EVPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> deleteAccountAdmin() async {
    try {
      await UserRepository.instance.removeAdminRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
      Get.offAll(() => const AdminLoginScreen());
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw EVFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EVFormatException();
    } on PlatformException catch (e) {
      throw EVPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
