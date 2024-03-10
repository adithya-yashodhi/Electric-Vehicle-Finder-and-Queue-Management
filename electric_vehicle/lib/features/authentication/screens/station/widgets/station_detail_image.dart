import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import '../../../../../common/widgets/icon/ev_circular_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class EVStationImage extends StatelessWidget {
  const EVStationImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = EVHelperFunctions.isDarkMode(context);
    return EVCurvedEdgeWidget(
      child: Container(
        color: dark ? EVColors.darkerGrey : EVColors.light,
        child: const Stack(
          children: [
            SizedBox(
              height: 400,
              child: Padding(
                padding: EdgeInsets.all(EVSizes.stationImageRadius),
                child: Center(child: Image(image: AssetImage(EVImages.stationImage))),
              ),
            ),
            EVAppBar(
              showBackArrow: true,
            )
          ],
        ),
      ),
    );
  }
}