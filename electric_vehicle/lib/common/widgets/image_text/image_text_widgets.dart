import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class EVVerticalImageText extends StatelessWidget {
  const EVVerticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.textColor = EVColors.black,
    this.backgroundColor =EVColors.white,
    this.onTap,
  });

  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {

    final dark = EVHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 90,
            padding: const EdgeInsets.all(EVSizes.sm),
            decoration: BoxDecoration(
              color: backgroundColor ?? (dark ? EVColors.black : EVColors.white),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Image(
                  image: AssetImage(image),
                  fit: BoxFit.cover
              ),
            ),
          ),
          const SizedBox(height: EVSizes.spaceBtwItems / 2),
          SizedBox(
            width: 55,
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .apply(color: textColor),
              maxLines: 2,
              //overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}