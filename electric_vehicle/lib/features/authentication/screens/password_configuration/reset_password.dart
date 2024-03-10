import 'package:electric_vehicle/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:electric_vehicle/features/authentication/screens/login/user/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(EVSizes.defaultSpace),
          child: Column(
            children: [
              /// image
              Image(image: const AssetImage(EVImages.deliveredEmailIllustration), width: EVHelperFunctions.screenWidth() * 0.6,),
              const SizedBox(height: EVSizes.spaceBtwItems),

              /// email,title and subtitle
              Text(email, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: EVSizes.spaceBtwItems),
              Text(EVTexts.changeYourPasswordTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: EVSizes.spaceBtwItems),
              Text(EVTexts.changeYourPasswordSubTitle, style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center),
              const SizedBox(height: EVSizes.spaceBtwItems),

              /// buttons
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Get.offAll(() => const LoginScreen()), child: const Text(EVTexts.done)),
              ),
              const SizedBox(height: EVSizes.spaceBtwItems),
              SizedBox(width: double.infinity, child: TextButton(onPressed: () => ForgetPasswordController.instance.resendPasswordResetEmail(email), child: const Text(EVTexts.resendEmail)),
              ),
              const SizedBox(height: EVSizes.spaceBtwItems),
            ],
          ),
        ),
      ),
    );
  }
}
