import 'package:electric_vehicle/common/widgets/heading/section_heading.dart';
import 'package:electric_vehicle/data/repositories/vehicle/vehicle_repository.dart';
import 'package:electric_vehicle/features/personalization/screens/vehicle/add_new_vehicle.dart';
import 'package:electric_vehicle/features/personalization/screens/vehicle/model/vehicle_model.dart';
import 'package:electric_vehicle/features/personalization/screens/vehicle/widgets/single_vehicle.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:electric_vehicle/utils/helpers/cloud_helper_functions.dart';
import 'package:electric_vehicle/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../network_manager.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/popups/full_screen_loader.dart';

class VehicleController extends GetxController {
  static VehicleController get instance => Get.find();

  final vehicleModel = TextEditingController();
  final vehicleNumber = TextEditingController();
  final batteryCapacity = TextEditingController();
  final portType = TextEditingController();
  final chargingPower = TextEditingController();
  String fastChargingSupport = '';
  GlobalKey<FormState> vehicleFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;
  final Rx<VehicleModel> selectedVehicle = VehicleModel.empty().obs;
  final vehicleRepository = Get.put(VehicleRepository());

  ///fetch all user specific vehicle
  Future<List<VehicleModel>> getAllUserVehicles() async {
    try{
      final vehicles = await vehicleRepository.fetchUserVehicles();
      selectedVehicle.value = vehicles.firstWhere((element) => element.selectedVehicle, orElse: () => VehicleModel.empty());
      return vehicles;
    }
    catch(e){
      EVLoaders.errorSnackBar(title: 'Vehicle not found', message: e.toString());
      return [];
    }
  }

  Future selectVehicle(VehicleModel newSelectedVehicle) async {
    try{
      Get.defaultDialog(
        title: '',
        onWillPop: () async {
          return false;
        },
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const CircularProgressIndicator(),
      );

      // clear the selected field
      if(selectedVehicle.value.id.isNotEmpty){
        await vehicleRepository.updateSelectedField(selectedVehicle.value.id, false);
      }

      // assign selected vehicle
      newSelectedVehicle.selectedVehicle = true;
      selectedVehicle.value = newSelectedVehicle;

      //  set the 'selected' field to true for the newly selected address
      await vehicleRepository.updateSelectedField(selectedVehicle.value.id, true);
      update();
      Get.back();
    } catch(e) {
      EVLoaders.errorSnackBar(title: 'Error in selection', message: e.toString());
    }
  }

  /// add new vehicle
  Future addNewVehicle() async {
    try{
      // start loading
      EVFullScreenLoader.openLoadingDialog(
          'Storing Data....', EVImages.docerAnimation);

      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EVFullScreenLoader.stopLoading();
        return;
      }

      // form validation
      if (!vehicleFormKey.currentState!.validate()) {
        EVFullScreenLoader.stopLoading();
        return;
      }

      // Map Data
      final vehicle = VehicleModel(
        id: '',
        vehicleModel: vehicleModel.text.trim(),
        vehicleNumber: vehicleNumber.text.trim(),
        batteryCapacity: batteryCapacity.text.trim(),
        portType: portType.text.trim(),
        chargingPower: chargingPower.text.trim(),
        fastChargingSupport: fastChargingSupport.trim(),
        selectedVehicle: true,
      );
      final id = await vehicleRepository.addVehicle(vehicle);

      // update selected address status
      vehicle.id = id;
      await selectVehicle(vehicle);

      EVFullScreenLoader.stopLoading();

      EVLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your vehicle data has been saved successfully.');

      // refresh vehicles data
      refreshData.toggle();

      resetFormFields();

      Navigator.of(Get.context!).pop();

    } catch (e) {
      EVFullScreenLoader.stopLoading();
      EVLoaders.warningSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  Future<dynamic> selectNewAddressPopup(BuildContext context){
    return showModalBottomSheet(
        context: context,
        builder: (_) => SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(EVSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EVSectionHeading(title: 'Select Vehicle', showActionButton: false,),
                FutureBuilder(
                    future: getAllUserVehicles(),
                    builder: (_, snapshot) {
                      final response = EVCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
                      if(response != null) return response;
          
                      return ListView.builder(
                        shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) => EVSingleVehicle(
                              vehicle: snapshot.data![index],
                              onTap: () async {
                                await selectVehicle(snapshot.data![index]);
                               Get.back();
                              },
                          ),
                      );
                    },
                    ),
                const SizedBox(height: EVSizes.defaultSpace * 2),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const AddNewVehicleScreen()),
                    child: const Text('Add new vehicle'),
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }

  void resetFormFields() {
    vehicleModel.clear();
    vehicleNumber.clear();
    batteryCapacity.clear();
    portType.clear();
    chargingPower.clear();
    fastChargingSupport = '';
    vehicleFormKey.currentState?.reset();
  }

  Future cancel() async {
    resetFormFields();
    Navigator.of(Get.context!).pop();
  }

}

