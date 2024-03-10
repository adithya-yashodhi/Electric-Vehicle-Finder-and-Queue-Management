import 'package:electric_vehicle/common/widgets/appbar/appbar.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:electric_vehicle/utils/constants/text_strings.dart';
import 'package:electric_vehicle/utils/validation/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../authentication/controllers/profile/update_email_controller.dart';

class ChangeEmail extends StatelessWidget {
  const ChangeEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateEmailController());
    return Scaffold(
      /// custom appbar
      appBar: EVAppBar(
        showBackArrow: true,
        title: Text('Change Email', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(EVSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///headings
            Text('Use real Email for easy verification.',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: EVSizes.spaceBtwSections),

            /// text field and button
            Form(
                key: controller.updateEmailFormKey,
                child: Column(
                  children: [
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.email,
                      validator: (value) => EVValidator.validateEmptyText('Email', value),
                      expands: false,
                      decoration: const InputDecoration(labelText: EVTexts.email, prefixIcon: Icon(Iconsax.direct)),
                    ),
                  ],
                )),
            const SizedBox(height: EVSizes.spaceBtwSections),

            /// save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.updateEmail(), child: const Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}
