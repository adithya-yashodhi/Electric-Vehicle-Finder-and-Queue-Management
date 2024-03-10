import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validation/validator.dart';
import '../../../controllers/login/admin_login_controller.dart';
import '../../password_configuration/forget_password.dart';
import '../../signup/admin/admin_signup.dart';

class AdminLoginForm extends StatelessWidget {
  const AdminLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminLoginController());
    return Form(
      key: controller.adminLoginFormKey,
      child: Padding(
      padding: const EdgeInsets.symmetric(vertical: EVSizes.spaceBtwSections),
      child: Column(
        children: [
          /// username
          TextFormField(
            controller: controller.email,
            validator: (value) => EVValidator.validateEmail(value),
            decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: EVTexts.username),
          ),
          const SizedBox(height: EVSizes.spaceBtwInputFields),

          ///password
          Obx(
                () => TextFormField(
              controller: controller.password,
              validator: (value) => EVValidator.validatePassword(value),
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
              TextButton(onPressed: () => Get.to(() => const ForgetPassword()), child: const Text(EVTexts.forgetPassword),)
            ],
          ),
          const SizedBox(height: EVSizes.spaceBtwSections),

          ///Sign in button
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.emailAndPasswordSignIn(), child: const Text(EVTexts.signIn))),
          const SizedBox(height: EVSizes.spaceBtwItems),

          ///create account button
          SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => Get.to(() => const AdminSignupScreen()), child: const Text(EVTexts.createAccount))),
        ],
      ),
    ),
    );
  }
}
