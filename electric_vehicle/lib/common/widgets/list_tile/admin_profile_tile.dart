import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';

import '../../../features/personalization/controllers/admin_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../effect/shimmer.dart';
import '../images/EVCircular_image.dart';

class AdminProfileTile extends StatelessWidget {
  const AdminProfileTile({
    super.key, required this.onPressedEdit, required this.onPressedAdd,
  });

  final VoidCallback onPressedEdit, onPressedAdd;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminController());
    return ListTile(
      leading:  Obx(() {
        final networkImage = controller.user.value.profilePicture;
        final image = networkImage.isNotEmpty ? networkImage : EVImages.user;
        return controller.imageUploading.value
            ? const EVShimmerEffect(width: 80, height: 80, radius: 80)
            : EVCircularImage(image: image, width: 80, height: 80, isNetworkImage: networkImage.isNotEmpty);
      } ),
      title: Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineSmall!.apply(color: EVColors.white)),
      subtitle: Row(
        children: [
          Expanded(
              child: Text(controller.user.value.email, style: Theme.of(context).textTheme.bodyMedium!.apply(color: EVColors.white),
                overflow: TextOverflow.ellipsis,)),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: onPressedEdit, icon: const Icon(Iconsax.edit, color: EVColors.white)),
          IconButton(onPressed: onPressedAdd, icon: const Icon(Iconsax.arrow_circle_down, color: EVColors.white)),
        ],
      ),
    );
  }
}