import 'package:electric_vehicle/features/authentication/screens/login/user/widgets/login_form.dart';
import 'package:electric_vehicle/features/authentication/screens/login/user/widgets/login_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../admin/admin_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30.0),
        child: AppBar(
          toolbarHeight: 30.0,
          actions: [
            PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Logging as Admin"),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  Get.to(() => const AdminLoginScreen());
                }
              },
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey), // Add grey outline
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(EVSizes.defaultSpace),
          child: Column(
            children: [
              ///logo, title and sub-title
              const EVLoginHeader(),

              ///Form
              const EVLoginForm(),

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
