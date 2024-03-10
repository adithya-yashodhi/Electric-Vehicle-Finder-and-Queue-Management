import 'package:electric_vehicle/features/personalization/screens/vehicle/controller/vehicle_controller.dart';
import 'package:electric_vehicle/features/personalization/screens/vehicle/widgets/vehicle_category.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:electric_vehicle/utils/validation/validator.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/image_strings.dart';

class AddNewVehicleScreen extends StatefulWidget {
  const AddNewVehicleScreen({super.key});

  @override
  State<AddNewVehicleScreen> createState() => _AddNewVehicleScreenState();
}

class _AddNewVehicleScreenState extends State<AddNewVehicleScreen> {

  @override
  Widget build(BuildContext context) {
    final controller = VehicleController.instance;
    String? fastChargingSupportError;

    return Scaffold(
      appBar: EVAppBar(showBackArrow: true, title: Text('Add new Vehicle',style: Theme.of(context).textTheme.headlineSmall)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(EVSizes.defaultSpace),
          child: Column(
            children: [
              EVVehicleCategory(
                onItemClicked: (title) {
                  setState(() {
                    controller.vehicleModel.text = title;
                  });
                },
                images: const [
                  EVImages.leaf,
                  EVImages.hyundaiKona,
                ],
              ),
              Form(
                key: controller.vehicleFormKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: controller.vehicleModel,
                        validator: (value) => EVValidator.validateEmptyText('Model', value),
                        decoration: const InputDecoration(labelText: 'Model')),
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(
                        controller: controller.vehicleNumber,
                        validator: (value) => EVValidator.validateEmptyText('Vehicle Number', value),
                        decoration: const InputDecoration(labelText: 'Vehicle Number')),
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(
                        controller: controller.batteryCapacity,
                        validator: (value) => EVValidator.validateEmptyText('Battery Capacity', value),
                        decoration: const InputDecoration(labelText: 'Battery Capacity')),
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(
                        controller: controller.portType,
                        validator: (value) => EVValidator.validateEmptyText('Port Type', value),
                        decoration: const InputDecoration(labelText: 'Port Type')),
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(
                        controller: controller.chargingPower,
                        validator: (value) => EVValidator.validateEmptyText('Charging Power', value),
                        decoration: const InputDecoration(labelText: 'Charging Power')),
                    const SizedBox(height: EVSizes.spaceBtwSections),
                    // Radio buttons for fast charging support
                    Row(
                      children: [
                        Expanded(
                          child: Text('Fast Charging Support:', style: Theme.of(context).textTheme.bodyLarge),),
                      ]
                    ),
                    const SizedBox(height: EVSizes.spaceBtwSections/2),
                    Row(
                        children: [
                        Radio<String>(
                          value: 'yes',
                          groupValue: controller.fastChargingSupport,
                          onChanged: (value) {
                            setState(() {
                              controller.fastChargingSupport = value!;
                              fastChargingSupportError = null;
                            });
                            },
                        ),
                        Text('Yes',style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(width: EVSizes.spaceBtwSections),
                        Radio<String>(
                          value: 'no',
                          groupValue: controller.fastChargingSupport,
                          onChanged: (value) {
                            setState(() {
                              controller.fastChargingSupport = value!;
                              fastChargingSupportError = null;
                            });
                            },
                        ),
                        Text('No',style: Theme.of(context).textTheme.bodyLarge),
                        ]
                    ),
                    // Validation error message
                    if (fastChargingSupportError != null)
                      Text(
                        fastChargingSupportError!,
                        style: const TextStyle(color: Colors.red),
                      ),

                    const SizedBox(height: EVSizes.spaceBtwSections),

                    Row(
                      children: [
                        Expanded(child: ElevatedButton(onPressed: () => controller.addNewVehicle(),
                            child: const Text('Save'))),
                        const SizedBox(width: EVSizes.spaceBtwInputFields),
                        Expanded(child: OutlinedButton(onPressed: () => controller.cancel(),style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),),
                            child: const Text('Cancel', style: TextStyle(color: Colors.red)))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
