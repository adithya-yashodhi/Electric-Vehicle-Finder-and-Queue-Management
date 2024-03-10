import 'package:electric_vehicle/data/repositories/station/station_repository.dart';
import 'package:electric_vehicle/features/authentication/screens/admin_station/model/station_model.dart';
import 'package:electric_vehicle/utils/constants/image_strings.dart';
import 'package:electric_vehicle/utils/popups/full_screen_loader.dart';
import 'package:electric_vehicle/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../network_manager.dart';

class StationController extends GetxController {
  static StationController get instance => Get.find();

  final name = TextEditingController();
  final registerNo = TextEditingController();
  final description = TextEditingController();
  final phoneNo = TextEditingController();
  final address = TextEditingController();
  final longitude = TextEditingController();
  final latitude = TextEditingController();
  final imageUploading = false.obs;
  GlobalKey<FormState> stationFormKey = GlobalKey<FormState>();

  final StationRepository stationRepository = Get.put(StationRepository());
  Rx<StationModel> station = StationModel.empty().obs;

  final RxBool is24HourOpen = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStationRecord();
  }

  //fetch user record
  Future<void> fetchStationRecord() async {
    try {
      final List<StationModel> stations = await stationRepository.fetchStationDetails();
      if (stations.isNotEmpty) {
        station.value = stations.first;
        is24HourOpen.value = stations.first.isOpen24Hours; // Update is24HourOpen
      } else {
        station(StationModel.empty());
      }
    } catch (e) {
      station(StationModel.empty());
      rethrow;
    }
  }

  // Toggle is24HourOpen
  void toggle24HourOpen(bool value) {
    is24HourOpen.value = value;
  }

  // save station record
  Future saveStationDetail() async {
    try {
      // start Loading
      EVFullScreenLoader.openLoadingDialog(
          'Storing Data....', EVImages.docerAnimation);

      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EVFullScreenLoader.stopLoading();
        return;
      }

      // form validation
      if (!stationFormKey.currentState!.validate()) {
        EVFullScreenLoader.stopLoading();
        return;
      }

      // Map Data
      final stationData = StationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        stationName: name.text.trim(),
        registerNumber: registerNo.text.trim(),
        description: description.text.trim(),
        stationPhoneNumber: phoneNo.text.trim(),
        stationAddress: address.text.trim(),
        longitude: longitude.text.trim(),
        latitude: latitude.text.trim(),
        isOpen24Hours: is24HourOpen.value,
        profilePicture: station.value.profilePicture,
      );

      // save user data
      await stationRepository.saveStationRecord(stationData);

      // Refresh station details
      await fetchStationRecord();

      EVFullScreenLoader.stopLoading();
      EVLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your station data has been saved successfully.');

      resetFormFields();
      Navigator.of(Get.context!).pop();

    } catch (e) {
      EVFullScreenLoader.stopLoading();
      EVLoaders.warningSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  /// upload profile image
  uploadStationProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70, maxHeight: 512, maxWidth: 512);
      if(image != null){
        imageUploading.value = true;
        // upload image
        final imageUrl = await stationRepository.uploadStationImage('Admins/Images/StationImage/', image);

        // update user image record
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await stationRepository.updateStationSingleField(station.value.id, json);

        station.value.profilePicture = imageUrl;
        station.refresh();

        EVLoaders.warningSnackBar(title: 'Congratulations', message: 'Your profile image has been uploaded!');
      }
    } catch (e) {
      EVLoaders.warningSnackBar(title: 'Oh Snap', message: 'Something went wrong: $e');
    }
    finally{
      imageUploading.value = false;
    }
  }

  void resetFormFields() {
    name.clear();
    registerNo.clear();
    description.clear();
    phoneNo.clear();
    address.clear();
    longitude.clear();
    latitude.clear();
    stationFormKey.currentState?.reset();
  }

  Future cancel() async {
    resetFormFields();
    Navigator.of(Get.context!).pop();
  }

}
