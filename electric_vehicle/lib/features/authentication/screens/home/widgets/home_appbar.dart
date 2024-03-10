import 'package:electric_vehicle/features/personalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/effect/shimmer.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';

class EVHomeAppBar extends StatelessWidget {
  const EVHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return EVAppBar(
      showBackArrow: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(EVTexts.homeAppbarTitle,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .apply(color: EVColors.grey)),
          Obx(
            () {
              if (controller.profileLoading.value) {
                // display a shimmer loader while user profile is being loaded
                return const EVShimmerEffect(width: 80, height: 15);
              } else {
                return Text(controller.user.value.fullName,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .apply(color: EVColors.white));
              }
            },
          ),
        ],
      ),
    );
  }
}
