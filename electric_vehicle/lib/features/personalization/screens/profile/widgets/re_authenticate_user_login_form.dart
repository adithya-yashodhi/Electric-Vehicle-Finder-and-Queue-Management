import 'package:electric_vehicle/features/personalization/controllers/user_controller.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:electric_vehicle/utils/validation/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/text_strings.dart';

class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Re-Authenticate User')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(EVSizes.defaultSpace),
          child: Form(
            key: controller.reAuthFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// email
                TextFormField(
                  controller: controller.verifyEmail,
                  validator: EVValidator.validateEmail,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.direct_right), labelText: EVTexts.email),
                ),
                const SizedBox(height: EVSizes.spaceBtwInputFields),

                ///password
                Obx(
                      () => TextFormField(
                    controller: controller.verifyPassword,
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
                const SizedBox(height: EVSizes.spaceBtwSections),

                /// login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () => controller.reAuthenticateEmailAndPasswordUser(), child: const Text('Verify')),

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
