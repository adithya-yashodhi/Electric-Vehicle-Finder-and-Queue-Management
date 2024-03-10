import 'package:electric_vehicle/data/repositories/station/station_repository.dart';
import 'package:electric_vehicle/features/authentication/screens/admin_station/model/station_model.dart';
import 'package:electric_vehicle/utils/constants/image_strings.dart';
import 'package:electric_vehicle/utils/popups/full_screen_loader.dart';
import 'package:electric_vehicle/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../network_manager.dart';
import '../port_detail/model/port_model.dart';
import '../repository/port_repository.dart';

class PortController extends GetxController {
  static PortController get instance => Get.find();

  final portType = TextEditingController();
  final noOfPorts = TextEditingController();
  final capacity = TextEditingController();
  final charge = TextEditingController();
  final speed = TextEditingController();
  GlobalKey<FormState> portFormKey = GlobalKey<FormState>();

  final PortRepository portRepository = Get.put(PortRepository());
  Rx<PortModel> port = PortModel.empty().obs;
  RxList<PortModel> availablePorts = <PortModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStationRecord();
  }

  Future<void> fetchStationRecord() async {
    try {
      // Fetch the station record
      final List<StationModel> stations = await StationRepository.instance.fetchStationDetails();

      if (stations.isEmpty) {
        throw 'No station found for the authenticated user';
      }

      // Assuming you want to use the first station in the list
      final stationModel = stations.first;

      // Call fetchPortRecord with the obtained stationModel
      await fetchPortRecord(stationModel);
    } catch (e) {
      port(PortModel.empty());
      rethrow;
    }
  }

  //fetch user record
  Future<void> fetchPortRecord(StationModel station) async {
    try {
      final List<PortModel> ports = await portRepository.fetchPortDetails(station);
      if (ports.isNotEmpty) {
        availablePorts.assignAll(ports);
      } else {
        port(PortModel.empty());
      }
    } catch (e) {
      port(PortModel.empty());
      rethrow;
    }
  }

  // save station record
  Future savePortDetail() async {
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
      if (!portFormKey.currentState!.validate()) {
        EVFullScreenLoader.stopLoading();
        return;
      }

      // Map Data
      final port = PortModel(
          id: UniqueKey().toString(),
          portType: portType.text.trim(),
          noOfPort: noOfPorts.text.trim(),
          capacity: capacity.text.trim(),
          charge: charge.text.trim(),
          speed: speed.text.trim());

      // Fetch Station Data
      final List<StationModel> stations =
      await StationRepository.instance.fetchStationDetails();

      // Check if stations list is not empty
      if (stations.isEmpty) {
        throw 'No station found for the authenticated user';
      }

      // Assuming you want to use the first station in the list
      final stationModel = stations.first;

      // save user data
      await portRepository.savePortRecord(port, stationModel);

      // Refresh port details
      await fetchPortRecord(stationModel);

      EVFullScreenLoader.stopLoading();
      EVLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your port data has been saved successfully.');

      resetFormFields();
      Navigator.of(Get.context!).pop();
    } catch (e) {
      EVFullScreenLoader.stopLoading();
      EVLoaders.warningSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void resetFormFields() {
    portType.clear();
    noOfPorts.clear();
    capacity.clear();
    charge.clear();
    speed.clear();
    portFormKey.currentState?.reset();
  }

  Future cancel() async {
    resetFormFields();
    Navigator.of(Get.context!).pop();
  }

}
