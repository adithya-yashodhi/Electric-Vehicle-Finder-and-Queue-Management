import 'package:electric_vehicle/features/authentication/screens/map/google_map.dart';
import 'package:electric_vehicle/features/personalization/screens/notification/notification.dart';
import 'package:electric_vehicle/utils/constants/colors.dart';
import 'package:electric_vehicle/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'features/authentication/screens/home/home.dart';
import 'features/personalization/screens/myBooking/my_booking.dart';
import 'features/personalization/screens/settings/settings.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = EVHelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? EVColors.black : EVColors.white,
          indicatorColor: darkMode
              ? EVColors.white.withOpacity(0.1)
              : EVColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.map), label: 'Map'),
            NavigationDestination(
                icon: Icon(Iconsax.calendar), label: 'Reservation'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const GoogleMapWidget(),
    const MyBooking(),
    const SettingsScreen()
  ];
}
