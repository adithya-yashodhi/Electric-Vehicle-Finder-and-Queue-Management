import 'package:electric_vehicle/utils/constants/colors.dart';
import 'package:electric_vehicle/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';

class EVAppBar extends StatelessWidget implements PreferredSizeWidget{
  const EVAppBar({super.key,
    this.title,
    this.showBackArrow = true,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed});

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    final dark = EVHelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: EVSizes.md),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(onPressed: () => Get.back(), icon: Icon(Iconsax.arrow_left, color: dark ? EVColors.white : EVColors.dark))
            : leadingIcon != null ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon)) : null,
      title: title,
      actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(EVDeviceUtils.getAppBarHeight());
}
