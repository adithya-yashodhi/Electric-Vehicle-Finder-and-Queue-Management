import 'package:electric_vehicle/features/personalization/screens/account/bottom_sheet.dart';
import 'package:electric_vehicle/features/personalization/screens/admin_reservation/admin_reservation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/container/primary_header_container.dart';
import '../../../../common/widgets/heading/section_heading.dart';
import '../../../../common/widgets/list_tile/admin_profile_tile.dart';
import '../../../../common/widgets/list_tile/settings_menu_tile.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../profile/admin/admin_profile.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///-- header
            EVPrimaryHeaderContainer(
              child: Column(
                children: [
                  EVAppBar(
                      title: Text('Account',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .apply(color: EVColors.white))),
                  // const SizedBox(height: EVSizes.spaceBtwSections),

                  /// user profile card
                  AdminProfileTile(
                      onPressedEdit: () { Get.to(() => const AdminProfileScreen());},
                      onPressedAdd: (){ showModalBottomSheet(context: context, builder: (context) =>
                      const AddAccountScreen(),
                      );
                      }),
                  const SizedBox(height: EVSizes.spaceBtwSections),
                ],
              ),
            ),

            /// body
            Padding(
              padding: const EdgeInsets.all(EVSizes.defaultSpace),
              child: Column(
                children: [
                  /// -- account settings
                  const EVSectionHeading(
                    title: 'Account Settings',
                    showActionButton: false,
                  ),
                  const SizedBox(height: EVSizes.spaceBtwItems),

                  EVSettingsMenuTile(
                      icon: Iconsax.calendar,
                      title: 'Reservation',
                      subTitle: 'In-progress and Completed bookings',
                  onTap: () => Get.to(() => const AdminReservationScreen()),),
                  const EVSettingsMenuTile(
                      icon: Iconsax.notification,
                      title: 'Notifications',
                      subTitle: 'Set any kind of notification message'),
                  const EVSettingsMenuTile(
                      icon: Iconsax.security_card,
                      title: 'Account Privacy',
                      subTitle: 'Manage data usage and connected accounts'),

                  /// -- app settings
                  const SizedBox(height: EVSizes.spaceBtwSections),
                  const EVSectionHeading(
                      title: 'App Settings', showActionButton: false),
                  const SizedBox(height: EVSizes.spaceBtwItems),
                  EVSettingsMenuTile(
                      icon: Iconsax.location,
                      title: 'Geolocation',
                      subTitle: 'Set recommendation based on location',
                      trailing: Switch(value: true, onChanged: (value) {})),
              EVSettingsMenuTile(
                      icon: Iconsax.image,
                      title: 'HD image Quality',
                      subTitle: 'Set image quality to be seen',
                      trailing: Switch(value: false, onChanged: (value) {})),

                  /// -- logout button
                  const SizedBox(height: EVSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () => AuthenticationRepository.instance.logout(), child: const Text('Logout')),
                  ),
                  const SizedBox(height: EVSizes.spaceBtwSections * 2.5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


