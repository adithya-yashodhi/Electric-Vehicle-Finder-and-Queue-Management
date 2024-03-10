import 'package:electric_vehicle/features/authentication/controllers/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';

class EVSocialButtons extends StatelessWidget {
  const EVSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: EVColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () => controller.googleSignIn(),
            icon: const Image(
              width: EVSizes.iconLg,
              height: EVSizes.iconLg,
              image: AssetImage(EVImages.google),
            ),
          ),
        ),
        const SizedBox(width: EVSizes.spaceBtwItems),
        Container(
          decoration: BoxDecoration(border: Border.all(color: EVColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: EVSizes.iconMd,
              height: EVSizes.iconMd,
              image: AssetImage(EVImages.facebook),
            ),
          ),
        ),
      ],
    );
  }
}



