import 'package:flutter/material.dart';

import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';
import '../../../../../../utils/helpers/helper_functions.dart';

class EVLoginHeader extends StatelessWidget {
  const EVLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EVHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          height: 150,
          image: AssetImage(dark ? EVImages.lightAppLogo : EVImages.darkAppLogo),
        ),
        Text(EVTexts.loginTitle, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: EVSizes.sm),
        Text(EVTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

