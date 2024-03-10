import 'package:electric_vehicle/common/widgets/appbar/appbar.dart';
import 'package:electric_vehicle/features/personalization/screens/profile/admin/update/controller/update_admin_phonenumber_controller.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:electric_vehicle/utils/constants/text_strings.dart';
import 'package:electric_vehicle/utils/validation/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class ChangeAdminPhoneNumber extends StatelessWidget {
  const ChangeAdminPhoneNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateAdminPhoneNumberController());
    return Scaffold(
      /// custom appbar
      appBar: EVAppBar(
        showBackArrow: true,
        title: Text('Change PhoneNumber', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(EVSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///headings
            Text('Use real phone number for easy verification.',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: EVSizes.spaceBtwSections),

            /// text field and button
            Form(
                key: controller.updateAdminPhoneNumberFormKey,
                child: Column(
                  children: [
                    const SizedBox(height: EVSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.adminPhoneNumber,
                      validator: (value) => EVValidator.validateEmptyText('Phone Number', value),
                      expands: false,
                      decoration: const InputDecoration(labelText: EVTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
                    ),
                  ],
                )),
            const SizedBox(height: EVSizes.spaceBtwSections),

            /// save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.updateAdminPhoneNumber(), child: const Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}
