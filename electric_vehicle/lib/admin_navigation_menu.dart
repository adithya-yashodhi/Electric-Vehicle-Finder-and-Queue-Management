import 'package:electric_vehicle/features/personalization/screens/admin_reservation/admin_reservation.dart';
import 'package:electric_vehicle/utils/constants/colors.dart';
import 'package:electric_vehicle/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'features/authentication/screens/admin_station/controller/station_controller.dart';
import 'features/authentication/screens/admin_station/station_info.dart';
import 'features/authentication/screens/home/admin/admin_home.dart';
import 'features/personalization/screens/settings/admin_settings.dart';

class AdminNavigationMenu extends StatelessWidget {
  const AdminNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminNavigationController());
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
            NavigationDestination(icon: Icon(Icons.charging_station_outlined), label: 'Station'),
            NavigationDestination(icon: Icon(Iconsax.calendar), label: 'Reservation'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class AdminNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const AdminHomeScreen(),
    const StationInformationScreen(),
    const AdminReservationScreen(),
    const AdminSettingsScreen()
  ];
}
