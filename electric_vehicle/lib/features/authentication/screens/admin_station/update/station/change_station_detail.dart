import 'package:electric_vehicle/common/widgets/appbar/appbar.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:electric_vehicle/utils/validation/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'change_station_detail_controller.dart';

class ChangeStationDetail extends StatelessWidget {
  const ChangeStationDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateStationDetailController());
    return Scaffold(
      /// custom appbar
      appBar: EVAppBar(
        showBackArrow: true,
        title: Text('Change Station Detail', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(EVSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///headings
            Text('Use real Station detail for easy use.',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: EVSizes.spaceBtwSections),

            /// text field and button
            Form(
                key: controller.updateStationDetailFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.description,
                      validator: (value) => EVValidator.validateEmptyText('Description', value),
                      decoration: const InputDecoration(labelText: 'Description'),maxLines: 2,),
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(
                        controller: controller.phoneNo,
                        validator: (value) => EVValidator.validatePhoneNumber(value),
                        decoration: const InputDecoration(labelText: 'Contact Number')),
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(
                        controller: controller.address,
                        validator: (value) => EVValidator.validateEmptyText('Charging Station Address', value),
                        decoration: const InputDecoration(labelText: 'Charging Station Address')),
                  ],
                )),
            const SizedBox(height: EVSizes.spaceBtwSections),

            /// save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.updateStationInfo(), child: const Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}
