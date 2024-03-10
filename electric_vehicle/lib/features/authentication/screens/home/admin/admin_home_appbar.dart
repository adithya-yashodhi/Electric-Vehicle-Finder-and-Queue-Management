import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/effect/shimmer.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../personalization/controllers/admin_controller.dart';

class EVAdminHomeAppBar extends StatelessWidget {
  const EVAdminHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminController());
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
