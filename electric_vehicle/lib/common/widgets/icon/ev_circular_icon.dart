import 'package:electric_vehicle/utils/constants/colors.dart';
import 'package:electric_vehicle/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class EVCircularIcon extends StatelessWidget {
  const EVCircularIcon(
      {super.key,
      this.width,
      this.height,
      this.size,
      required this.icon,
      this.color,
      this.backgroundColor,
      this.onPressed});

  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor != null
            ? backgroundColor!
            : EVHelperFunctions.isDarkMode(context)
                ? EVColors.black.withOpacity(0.9)
                : EVColors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
          onPressed: onPressed, icon: Icon(icon, color: color, size: size)),
    );
  }
}
