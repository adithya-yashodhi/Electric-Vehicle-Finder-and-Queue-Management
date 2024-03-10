import 'package:electric_vehicle/features/authentication/screens/admin_station/controller/station_controller.dart';
import 'package:electric_vehicle/utils/validation/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';

class AddStationScreen extends StatelessWidget {
  const AddStationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StationController.instance;

    return Scaffold(
      appBar: EVAppBar(showBackArrow: true, title: Text('Add new Station',style: Theme.of(context).textTheme.headlineSmall)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(EVSizes.defaultSpace),
          child: Column(
            children: [
              Form(
                key: controller.stationFormKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: controller.name,
                        validator: (value) => EVValidator.validateEmptyText('Station Name', value),
                        decoration: const InputDecoration(labelText: 'Station Name')),
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(controller: controller.registerNo,
                        validator: (value) => EVValidator.validateEmptyText('Registration Number', value),
                        decoration: const InputDecoration(labelText: 'Registration Number')),
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(controller: controller.description,
                      validator: (value) => EVValidator.validateEmptyText('Description', value),
                      decoration: const InputDecoration(labelText: 'Description'),maxLines: 2,),
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(controller: controller.phoneNo,
                        validator: (value) => EVValidator.validatePhoneNumber(value),
                        decoration: const InputDecoration(labelText: 'Contact Number')),
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(controller: controller.address,
                        validator: (value) => EVValidator.validateEmptyText('Charging Station Address', value),
                        decoration: const InputDecoration(labelText: 'Charging Station Address')),
                    const SizedBox(height: EVSizes.spaceBtwSections),
                    Row(
                      children: [
                        Expanded(child: TextFormField(controller: controller.longitude,
                            validator: (value) => EVValidator.validateEmptyText('Longitude', value),
                            decoration: const InputDecoration(labelText: 'Longitude')),),
                        const SizedBox(width: EVSizes.spaceBtwInputFields),
                        Expanded(child: TextFormField(controller: controller.latitude,
                            validator: (value) => EVValidator.validateEmptyText('Latitude', value),
                            decoration: const InputDecoration(labelText: 'Latitude')),),
                      ],
                    ),
                    Row(
                      children: [
                        Obx (
                        () => Checkbox(
                          value: controller.is24HourOpen.value,
                          onChanged: (value) {
                            controller.toggle24HourOpen(value ?? false);
                          },),
                        ),
                        const SizedBox(width: EVSizes.spaceBtwInputFields),
                        const Text('Open 24 Hours'),
                      ],
                    ),
                    const SizedBox(height: EVSizes.spaceBtwSections),
                    Row(
                      children: [
                        Expanded(child: ElevatedButton(onPressed: () => controller.saveStationDetail(), child: const Text('Save'))),
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
