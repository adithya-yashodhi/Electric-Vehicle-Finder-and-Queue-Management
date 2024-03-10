import 'package:electric_vehicle/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(EVSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(EVTexts.signUpTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: EVSizes.spaceBtwSections),

              /// form
              const EVSignupForm(),
              const SizedBox(height: EVSizes.spaceBtwSections),

              /// Divider
              EVFormDivider(dividerText: EVTexts.orSignUpWith.capitalize!),
              const SizedBox(height: EVSizes.spaceBtwSections),

              /// social buttons
              const EVSocialButtons(),
            ],
          ),
        )
      ),
    );
  }
}


