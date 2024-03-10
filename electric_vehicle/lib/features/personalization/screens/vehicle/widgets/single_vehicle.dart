import 'package:electric_vehicle/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:electric_vehicle/features/personalization/screens/vehicle/controller/vehicle_controller.dart';
import 'package:electric_vehicle/features/personalization/screens/vehicle/model/vehicle_model.dart';
import 'package:electric_vehicle/utils/constants/colors.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:electric_vehicle/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EVSingleVehicle extends StatelessWidget {
  const EVSingleVehicle(
      {super.key, required this.vehicle, required this.onTap,});

  final VehicleModel vehicle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final controller = VehicleController.instance;
    final dark = EVHelperFunctions.isDarkMode(context);

    return Obx(() {
      final selectedVehicleId = controller.selectedVehicle.value.id;
      final selectedVehicle = selectedVehicleId == vehicle.id;
      return InkWell(
        onTap: onTap,
        child: EVRoundedContainer(
          padding: const EdgeInsets.all(EVSizes.md),
          width: double.infinity,
          showBorder: true,
          backgroundColor: selectedVehicle ? EVColors.primary.withOpacity(
              0.5) : Colors.transparent,
          borderColor: selectedVehicle ? Colors.transparent : dark
              ? EVColors.darkerGrey
              : EVColors.grey,
          margin: const EdgeInsets.only(bottom: EVSizes.spaceBtwItems),
          child: Stack(
            children: [
              Positioned(
                right: 5,
                top: 0,
                child: Icon(
                  selectedVehicle ? Iconsax.tick_square5 : null,
                  color: selectedVehicle ? dark ? EVColors.light : EVColors
                      .dark : null,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(vehicle.vehicleModel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  const SizedBox(height: EVSizes.sm / 2),
                  Row(
                      children: [
                        Text(vehicle.vehicleNumber, style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: EVColors.black)),
                        const SizedBox(width: EVSizes.sm / 2),
                        const Text('CAR 0050', maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ]
                  ),
                  const SizedBox(height: EVSizes.sm / 2),
                  Row(
                      children: [
                        Text(vehicle.batteryCapacity, style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: EVColors.black)),
                        const SizedBox(width: EVSizes.sm / 2),
                        const Text('40kW', maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ]
                  ),
                  const SizedBox(height: EVSizes.sm / 2),
                  Row(
                      children: [
                        Text(vehicle.portType, style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: EVColors.black)),
                        const SizedBox(width: EVSizes.sm / 2),
                        const Text('Type 1(JI772)', maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ]
                  ),
                  const SizedBox(height: EVSizes.sm / 2),
                  Row(
                      children: [
                        Text(vehicle.chargingPower, style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: EVColors.black)),
                        const SizedBox(width: EVSizes.sm / 2),
                        const Text('6.6 kW', maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ]
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
        }
        }
