import 'package:electric_vehicle/features/authentication/screens/signup/admin/terms_conditions_checkbox.dart';
import 'package:electric_vehicle/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:electric_vehicle/utils/validation/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/signup/admin_signup_controller.dart';

class AdminSignupForm extends StatelessWidget {
  const AdminSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminSignupController());
    return Form(
      key: controller.adminSignupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) => EVValidator.validateEmptyText('First name', value),
                  expands : false,
                  decoration: const InputDecoration(labelText: EVTexts.firstName, prefixIcon: Icon(Iconsax.user)),
                ),
              ),
              const SizedBox(width: EVSizes.spaceBtwInputFields),
              Expanded(child: TextFormField(
                controller: controller.lastName,
                validator: (value) => EVValidator.validateEmptyText('Last name', value),
                expands : false,
                decoration: const InputDecoration(labelText: EVTexts.lastName, prefixIcon: Icon(Iconsax.user)),
              ),
              ),
            ],
          ),
          const SizedBox(height: EVSizes.spaceBtwInputFields),

          /// username
          TextFormField(
            controller: controller.userName,
            validator: (value) => EVValidator.validateEmptyText('Username', value),
            expands : false,
            decoration: const InputDecoration(labelText: EVTexts.username, prefixIcon: Icon(Iconsax.user_edit)),
          ),
          const SizedBox(height: EVSizes.spaceBtwInputFields),

          /// email
          TextFormField(
            controller: controller.email,
            validator: (value) => EVValidator.validateEmail(value),
            expands : false,
            decoration: const InputDecoration(labelText: EVTexts.email, prefixIcon: Icon(Iconsax.direct)),
          ),
          const SizedBox(height: EVSizes.spaceBtwInputFields),

          /// phone number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => EVValidator.validatePhoneNumber(value),
            expands : false,
            decoration: const InputDecoration(labelText: EVTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
          ),
          const SizedBox(height: EVSizes.spaceBtwInputFields),

          /// password
          Obx(
                () => TextFormField(
              controller: controller.password,
              validator: (value) => EVValidator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: EVTexts.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                ),
              ),
            ),
          ),
          const SizedBox(height: EVSizes.spaceBtwSections),

          /// Terms and conditions checkbox
          const TermsAndConditionCheckbox(),
          const SizedBox(height: EVSizes.spaceBtwSections),

          /// sign up button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.adminSignup(),
              child: const Text(EVTexts.createAccount),
            ),
          ),
        ],
      ),);
  }
}

