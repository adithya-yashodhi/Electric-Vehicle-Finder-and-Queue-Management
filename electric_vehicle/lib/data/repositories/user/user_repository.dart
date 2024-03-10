import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electric_vehicle/data/repositories/authentication/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../features/personalization/models/user/user_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// function to save user data to firestore
  Future<void> saveUserRecord(UserModel user) async{
    try{
      await _db.collection("Users").doc(user.id).set(user.toJson());
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

  /// function to fetch user data based on user ID
  Future<UserModel> fetchUserDetails() async{
    try{
      final documentSnapShot = await _db.collection("Users").doc(AuthenticationRepository.instance.authUser?.uid).get();
      if(documentSnapShot.exists) {
        return UserModel.fromSnapshot(documentSnapShot);
      }else {
        return UserModel.empty();
      }
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseException(e.code).message;
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

  /// function to update user data based on user ID
  Future<void> updateUserDetails(UserModel updateUser) async{
    try{
      await _db.collection("Users").doc(updateUser.id).set(updateUser.toJson());
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseException(e.code).message;
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

  /// update any field in specific users collection
  Future<void> updateSingleField(Map<String, dynamic> json) async{
    try{
      await _db.collection("Users").doc(AuthenticationRepository.instance.authUser?.uid).update(json);
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseException(e.code).message;
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

  /// function to remove user data from firestore
  Future<void> removeUserRecord(String userId) async{
    try{
      await _db.collection("Users").doc(userId).delete();
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseException(e.code).message;
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

  /// upload any image
  Future<String> uploadImage(String path, XFile image) async {
    try{

      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;

    } on FirebaseAuthException catch (e) {
      throw EVFirebaseException(e.code).message;
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

  /*------------------------------ Admin ---------------------------------------*/

  /// function to save admin data to firestore
  Future<void> saveAdminRecord(UserModel user) async{
    try{
      await _db.collection("Admin").doc(user.id).set(user.toJson());
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

  /// function to fetch user data based on user ID
  Future<UserModel> fetchAdminDetails() async{
    try{
      final documentSnapShot = await _db.collection("Admin").doc(AuthenticationRepository.instance.authUser?.uid).get();
      if(documentSnapShot.exists) {
        return UserModel.fromSnapshot(documentSnapShot);
      }else {
        return UserModel.empty();
      }
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseException(e.code).message;
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

  /// function to update user data based on user ID
  Future<void> updateAdminDetails(UserModel updateUser) async{
    try{
      await _db.collection("Admin").doc(updateUser.id).set(updateUser.toJson());
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseException(e.code).message;
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

  /// update any field in specific users collection
  Future<void> updateAdminSingleField(Map<String, dynamic> json) async{
    try{
      await _db.collection("Admin").doc(AuthenticationRepository.instance.authUser?.uid).update(json);
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseException(e.code).message;
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

  /// function to remove user data from firestore
  Future<void> removeAdminRecord(String userId) async{
    try{
      await _db.collection("Admin").doc(userId).delete();
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseException(e.code).message;
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

  /// upload any image
  Future<String> uploadAdminImage(String path, XFile image) async {
    try{

      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;

    } on FirebaseAuthException catch (e) {
      throw EVFirebaseException(e.code).message;
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

  /// update any field in specific Admin station collection
  Future<void> updateStationData(Map<String, dynamic> json) async {
    try {
      final user = AuthenticationRepository.instance.authUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("Admin")
            .doc(user.uid)
            .collection("Stations")
            .doc() // Specify the document ID if needed
            .update(json);
      }
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseException(e.code).message;
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

  /// update any field in specific Admin port collection
  Future<void> updatePortData(Map<String, dynamic> json) async {
    try {
      final user = AuthenticationRepository.instance.authUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("Admin")
            .doc(user.uid)
            .collection("Ports")
            .doc() // Specify the document ID if needed
            .update(json);
      }
    } on FirebaseAuthException catch (e) {
      throw EVFirebaseException(e.code).message;
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