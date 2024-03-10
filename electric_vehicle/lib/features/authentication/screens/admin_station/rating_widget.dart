import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
class RatingWidget extends StatelessWidget {
  const RatingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// rating
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Iconsax.star5, color: Colors.amber, size: 24),
            const SizedBox(width: EVSizes.spaceBtwItems / 2),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: '5.0',
                      style:
                      Theme.of(context).textTheme.bodyLarge),
                  const TextSpan(text: '(199)'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}