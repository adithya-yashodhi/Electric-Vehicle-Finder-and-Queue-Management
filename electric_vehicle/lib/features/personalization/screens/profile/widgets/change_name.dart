import 'package:electric_vehicle/common/widgets/appbar/appbar.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:electric_vehicle/utils/constants/text_strings.dart';
import 'package:electric_vehicle/utils/validation/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../authentication/controllers/profile/update_name_controller.dart';

class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());
    return Scaffold(
      /// custom appbar
      appBar: EVAppBar(
        showBackArrow: true,
        title: Text('Change Name', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(EVSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///headings
            Text('Use real name for easy verification. This will appear on several pages.',
            style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: EVSizes.spaceBtwSections),

            /// text field and button
            Form(
              key: controller.updateUserNameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.firstName,
                    validator: (value) => EVValidator.validateEmptyText('First name', value),
                    expands: false,
                    decoration: const InputDecoration(labelText: EVTexts.firstName, prefixIcon: Icon(Iconsax.user)),
                  ),
                  const SizedBox(height: EVSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: controller.lastName,
                    validator: (value) => EVValidator.validateEmptyText('Last name', value),
                    expands: false,
                    decoration: const InputDecoration(labelText: EVTexts.lastName, prefixIcon: Icon(Iconsax.user)),
                  ),
                ],
              )),
            const SizedBox(height: EVSizes.spaceBtwSections),

            /// save button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => controller.updateUserName(), child: const Text('Save')),
                ),
          ],
        ),
      ),
    );
  }
}
