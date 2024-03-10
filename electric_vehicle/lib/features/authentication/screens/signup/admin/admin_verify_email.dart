import 'package:electric_vehicle/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/signup/admin_email_controller.dart';



class AdminVerifyEmailScreen extends StatelessWidget {
  const AdminVerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminVerifyEmailController());
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(onPressed: () => AuthenticationRepository.instance.logout(), icon: const Icon(CupertinoIcons.clear))
          ],
        ),
        body: SingleChildScrollView(
          //Padding to give default equal space on all sides in all screens
          child: Padding(
            padding: const EdgeInsets.all(EVSizes.defaultSpace),
            child: Column(
              children: [
                ///Image
                Image(image: const AssetImage(EVImages.deliveredEmailIllustration),
                  width: EVHelperFunctions.screenWidth() * 0.6,),
                const SizedBox(height: EVSizes.spaceBtwItems),

                /// title and subtitle
                Text(EVTexts.confirmEmail, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: EVSizes.spaceBtwItems),
                Text(email ?? '', style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center),
                const SizedBox(height: EVSizes.spaceBtwItems),
                Text(EVTexts.confirmEmailSubTitle, style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center),
                const SizedBox(height: EVSizes.spaceBtwItems),

                /// buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => controller.checkEmailVerificationStatus(),
                      child: const Text(EVTexts.evContinue)),
                ),
                const SizedBox(height: EVSizes.spaceBtwItems),
                SizedBox(width: double.infinity, child: TextButton(onPressed: () => controller.sendEmailVerification(), child: const Text(EVTexts.resendEmail))),

              ],
            ),),
        )
    );
  }
}
