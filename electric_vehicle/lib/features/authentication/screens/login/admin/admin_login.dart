import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import 'admin_login_form.dart';
import 'admin_login_header.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30.0),
        child: AppBar(
          toolbarHeight: 30.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(EVSizes.defaultSpace),
          child: Column(
            children: [
              ///logo, title and sub-title
              const AdminLoginHeader(),

              ///Form
              const AdminLoginForm(),

              /// divider
              EVFormDivider(dividerText: EVTexts.orSignInWith.capitalize!),
              const SizedBox(height: EVSizes.spaceBtwSections),

              /// footer
              const EVSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
