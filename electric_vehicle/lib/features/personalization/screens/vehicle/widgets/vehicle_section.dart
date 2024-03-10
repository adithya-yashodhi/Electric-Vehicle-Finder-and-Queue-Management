import 'package:electric_vehicle/features/personalization/screens/vehicle/controller/vehicle_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/heading/section_heading.dart';
import '../../../../../utils/constants/sizes.dart';

class VehicleSection extends StatelessWidget {
  const VehicleSection({super.key});

  @override
  Widget build(BuildContext context) {

    //final vehicleController = Get.put(VehicleController());
    final vehicleController = Get.find<VehicleController>();
    
    return Obx( () {
      final selectedVehicle = vehicleController.selectedVehicle.value;

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          // Adjust border color and width as needed
          borderRadius: BorderRadius.circular(
              10.0), // Adjust border radius as needed
        ),
        padding: const EdgeInsets.all(EVSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EVSectionHeading(title: 'Charging Vehicle', buttonTitle: 'Change',
                onPressed: () =>
                    vehicleController.selectNewAddressPopup(context)),
            selectedVehicle.id.isNotEmpty ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(selectedVehicle.vehicleModel,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge,),
                    ),
                  ],
                ),
                const SizedBox(height: EVSizes.spaceBtwItems / 2),
                Row(
                  children: [
                    const Icon(Iconsax.car, color: Colors.grey, size: 16),
                    const SizedBox(width: EVSizes.spaceBtwItems / 2),
                    Expanded(
                      child: Text(selectedVehicle.vehicleNumber,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium),
                    )
                  ],
                )
              ],
            ) : Text('Select Vehicle', style: Theme
                .of(context)
                .textTheme
                .bodyMedium)

          ],
        ),
      );
    });
  }
}
