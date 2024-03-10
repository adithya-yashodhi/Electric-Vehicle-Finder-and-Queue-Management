import 'package:electric_vehicle/common/widgets/appbar/appbar.dart';
import 'package:electric_vehicle/features/personalization/screens/vehicle/add_new_vehicle.dart';
import 'package:electric_vehicle/features/personalization/screens/vehicle/controller/vehicle_controller.dart';
import 'package:electric_vehicle/features/personalization/screens/vehicle/widgets/single_vehicle.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:electric_vehicle/utils/helpers/cloud_helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';

class UserVehicleScreen extends StatelessWidget {
  const UserVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VehicleController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: EVColors.primary,
        onPressed: () => Get.to(() => const AddNewVehicleScreen()),
        child: const Icon(Iconsax.add, color: EVColors.white),
      ),
      appBar: EVAppBar(
        showBackArrow: true,
        title: Text('My Vehicles', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(EVSizes.defaultSpace),
        child: Obx(
            () => FutureBuilder(
            // use key to trigger refresh
            key: Key(controller.refreshData.value.toString()),
            future: controller.getAllUserVehicles(),
            builder: (context, snapshot) {

              /// helper function: handle loader, no record, or error message
              final response = EVCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
              if(response != null) return response;

              final vehicles = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: vehicles.length,
                itemBuilder: (_, index) =>
                  EVSingleVehicle(vehicle: vehicles[index], onTap: () => controller.selectVehicle(vehicles[index]),),
              );
            }
          ),
        )
      ),
    );
  }
}




