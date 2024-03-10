import 'package:electric_vehicle/common/widgets/appbar/appbar.dart';
import 'package:electric_vehicle/features/authentication/screens/admin_station/update/port/update_port_detail_controller.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:electric_vehicle/utils/validation/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePortDetail extends StatelessWidget {
  const ChangePortDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdatePortDetailController());

    final port = Get.arguments;
    controller.noOfPorts.text = port.noOfPort;
    controller.charge.text = port.charge;
    return Scaffold(
      /// custom appbar
      appBar: EVAppBar(
        showBackArrow: true,
        title: Text('Change Port Detail', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(EVSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///headings
            Text('Use real Port detail to easy usage for customer .',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: EVSizes.spaceBtwSections),

            /// text field and button
            Form(
                key: controller.updatePortDetailFormKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: controller.noOfPorts,
                        validator: (value) => EVValidator.validateEmptyText('Number of Ports', value),
                        decoration: const InputDecoration(labelText: 'Number of Ports')),
                    const SizedBox(height: EVSizes.spaceBtwSections),
                    TextFormField(
                        controller: controller.charge,
                        validator: (value) => EVValidator.validateEmptyText('Fee for 1hr (LKR)', value),
                        decoration: const InputDecoration(labelText: 'Fee for 1hr (LKR)')),
                  ],
                )),
            const SizedBox(height: EVSizes.spaceBtwSections),

            /// save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.updatePortInfo(), child: const Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}
