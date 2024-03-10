import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electric_vehicle/data/repositories/authentication/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../features/authentication/screens/admin_station/model/station_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class StationRepository extends GetxController {
  static StationRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String?> fetchStationIdByUserId(String userId) async {
    try {
      final querySnapshot = await _db
          .collection('Admin')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        throw 'Station not found for the authenticated user';
      }
    } catch (e) {
      throw 'Failed to fetch station ID: $e';
    }
  }

  /// function to save user data to firestore
  Future<void> saveStationRecord(StationModel station) async {
    try {
      if (station.id.isEmpty) {
        throw 'Station ID is null or empty';
      }
      // Get the current authenticated user
      final authUser = AuthenticationRepository.instance.authUser;

      // Check if the user is authenticated
      if (authUser == null) {
        throw 'User is not authenticated';
      }

      // Construct the path to the station document based on admin ID and station ID
      final docPath = "Admin/${authUser.uid}/Stations/${station.id}";

      // Set the station data at the specified path
      await _db.doc(docPath).set(station.toJson());
    } catch (e) {
      throw 'Failed to save station record: $e';
    }
  }


  /// function to fetch user data based on user ID
  Future<List<StationModel>> fetchStationDetails() async{
    try{
      final authUser = AuthenticationRepository.instance.authUser;

      if (authUser == null) {
        throw 'User is not authenticated';
      }

      // Construct the path to the station document based on admin ID
      final docPath = "Admin/${authUser.uid}/Stations";

      final querySnapshot = await _db.collection(docPath).get();

      final List<StationModel> stations = [];

      for (var documentSnapShot in querySnapshot.docs) {
        stations.add(StationModel.fromSnapshot(documentSnapShot));
      }

      return stations;
    }  catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// upload any image
  Future<String> uploadStationImage(String path, XFile image) async {
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

  Future<void> updateStationSingleField(String stationId, Map<String, dynamic> updates) async {
    try {
      final authUser = AuthenticationRepository.instance.authUser;
      if (authUser == null) {
        throw 'User is not authenticated';
      }

      final docPath = "Admin/${authUser.uid}/Stations/$stationId";
      await _db.doc(docPath).update(updates);
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