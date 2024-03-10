import 'package:electric_vehicle/features/authentication/controllers/signup/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class EVTermsAndConditionCheckbox extends StatelessWidget {
  const EVTermsAndConditionCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = EVHelperFunctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(
            () => Checkbox(
                value: controller.privacyPolicy.value,
                onChanged: (value) => controller.privacyPolicy.value =
                    !controller.privacyPolicy.value),
          ),
        ),
        const SizedBox(width: EVSizes.spaceBtwItems),
        Text.rich(
          TextSpan(children: [
            TextSpan(
                text: '${EVTexts.iAgreeTo} ',
                style: Theme.of(context).textTheme.bodySmall),
            TextSpan(
                text: '${EVTexts.privacyPolicy} ',
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: dark ? EVColors.white : EVColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: dark ? EVColors.white : EVColors.primary,
                    )),
            TextSpan(
                text: '${EVTexts.and} ',
                style: Theme.of(context).textTheme.bodySmall),
            TextSpan(
                text: '${EVTexts.termsOfUse} ',
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: dark ? EVColors.white : EVColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: dark ? EVColors.white : EVColors.primary,
                    )),
          ]),
        ),
      ],
    );
  }
}
