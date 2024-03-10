import 'package:electric_vehicle/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:electric_vehicle/utils/validation/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(EVSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// headings
            Text(EVTexts.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: EVSizes.spaceBtwItems),
            Text(EVTexts.forgetPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: EVSizes.spaceBtwSections * 2),

            /// text field
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: EVValidator.validateEmail,
                decoration: const InputDecoration(
                  labelText: EVTexts.email, prefixIcon: Icon(Iconsax.direct_right)
                ),
              ),
            ),
            const SizedBox(height: EVSizes.spaceBtwSections),

            /// submit button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => controller.sendPasswordResetEmail(), child: const Text(EVTexts.submit)))
          ],
        ),
      ),
    );
  }
}
