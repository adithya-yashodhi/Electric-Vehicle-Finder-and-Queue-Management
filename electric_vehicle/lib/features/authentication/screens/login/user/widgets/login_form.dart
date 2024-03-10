import 'package:electric_vehicle/features/authentication/controllers/login/login_controller.dart';
import 'package:electric_vehicle/utils/validation/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../password_configuration/forget_password.dart';
import '../../../signup/signup.dart';

class EVLoginForm extends StatelessWidget {
  const EVLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: EVSizes.spaceBtwSections),
        child: Column(
          children: [
            ///Email
            TextFormField(
              controller: controller.email,
              validator: (value) => EVValidator.validateEmail(value),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: EVTexts.email),
            ),
            const SizedBox(height: EVSizes.spaceBtwInputFields),

            ///password
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator: (value) => EVValidator.validateEmptyText('Password', value),
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  labelText: EVTexts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye),
                  ),
                ),
              ),
            ),
            const SizedBox(height: EVSizes.spaceBtwInputFields / 2),

            ///remember me and forget password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///remember me
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value),
                    ),
                    const Text(EVTexts.rememberMe),
                  ],
                ),

                /// forget password
                TextButton(
                  onPressed: () => Get.to(() => const ForgetPassword()),
                  child: const Text(EVTexts.forgetPassword),
                )
              ],
            ),
            const SizedBox(height: EVSizes.spaceBtwSections),

            ///Sign in button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => controller.emailAndPasswordSignIn(),
                    child: const Text(EVTexts.signIn))),
            const SizedBox(height: EVSizes.spaceBtwItems),

            ///create account button
            SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () => Get.to(() => const SignupScreen()),
                    child: const Text(EVTexts.createAccount))),
          ],
        ),
      ),
    );
  }
}
