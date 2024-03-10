import 'package:electric_vehicle/common/widgets/icon/ev_circular_icon.dart';
import 'package:electric_vehicle/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/custom_shapes/container/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';

class StationListWidget extends StatelessWidget {
  const StationListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = EVHelperFunctions.isDarkMode(context);
    return EVRoundedContainer(
      showBorder: true,
      padding: const EdgeInsets.all(EVSizes.md),
      backgroundColor: dark ? EVColors.dark : EVColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(EVTexts.station1Title,
                            style: Theme.of(context).textTheme.headlineSmall),
                        const Spacer(),
                        IconButton(onPressed: () {},
                            icon: const Icon(Icons.directions, size: EVSizes.iconLg, color: Color(0xff269E66))),
                        //const SizedBox(width: EVSizes.spaceBtwItems),
                        const Positioned(
                            top: 0,
                            right: 0,
                            child: EVCircularIcon(
                                icon: Iconsax.heart5, color: Colors.red)),
                      ],
                    ),
                    Text(
                      EVTexts.station1Address,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: EVColors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                      // Optional: handle overflow with ellipsis
                      maxLines: 2,
                    ),
                    // const SizedBox(height: EVSizes.spaceBtwItems / 1.5),
                    Text(
                      EVTexts.station1Tp,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: EVColors.textSecondary),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.electric_bolt,
                            color: Colors.amberAccent),
                        const SizedBox(width: 8),
                        Text(
                          EVTexts.station1Port1,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .apply(color: EVColors.textSecondary),
                        ),
                        Text(
                          EVTexts.station1Port2,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .apply(color: EVColors.textSecondary),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.electric_bolt,
                            color: Colors.amberAccent),
                        const SizedBox(width: 8),
                        Text(
                          EVTexts.station1Port2,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .apply(color: EVColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

