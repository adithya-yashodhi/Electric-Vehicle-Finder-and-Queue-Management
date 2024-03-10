import 'package:electric_vehicle/common/widgets/effect/shimmer.dart';
import 'package:electric_vehicle/features/personalization/screens/profile/widgets/change_email.dart';
import 'package:electric_vehicle/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:electric_vehicle/features/personalization/screens/profile/widgets/change_phonenumber.dart';
import 'package:electric_vehicle/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/heading/section_heading.dart';
import '../../../../common/widgets/images/EVCircular_image.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/user_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: const EVAppBar(showBackArrow: true, title: Text('Profile')),

      ///--body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(EVSizes.defaultSpace),
          child: Column(
            children: [
            /// profile picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = controller.user.value.profilePicture;
                      final image = networkImage.isNotEmpty ? networkImage : EVImages.user;
                      return controller.imageUploading.value
                        ? const EVShimmerEffect(width: 80, height: 80, radius: 80)
                          : EVCircularImage(image: image, width: 80, height: 80, isNetworkImage: networkImage.isNotEmpty);
                    } ),
                    TextButton(onPressed: () => controller.uploadUserProfilePicture(), child: const Text('Change Profile Picture')),
                  ],
                ),
              ),

              /// Details
              const SizedBox(height: EVSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: EVSizes.spaceBtwItems),

              /// heading profile info
              const EVSectionHeading(title: 'Profile Information', showActionButton: false),
              const SizedBox(height: EVSizes.spaceBtwItems),

              EVProfileMenu(title: 'Name', value: controller.user.value.fullName, onPressed: () => Get.to(const ChangeName())),
              EVProfileMenu(title: 'Username', value: controller.user.value.username, onPressed: () {}),

              const SizedBox(height: EVSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: EVSizes.spaceBtwItems),

              /// heading personal info
              const EVSectionHeading(title: 'Personal Information', showActionButton: false),
              const SizedBox(height: EVSizes.spaceBtwItems),

              EVProfileMenu(title: 'User ID', value: controller.user.value.id, icon: Iconsax.copy, onPressed: () {}),
              EVProfileMenu(title: 'E-mail', value: controller.user.value.email, onPressed: () => Get.to(const ChangeEmail()) ),
              EVProfileMenu(title: 'Phone Number', value: controller.user.value.phoneNumber, onPressed: () => Get.to(const ChangePhoneNumber())),
              const Divider(),
              const SizedBox(height: EVSizes.spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(),
                  child: const Text('Delete Account', style: TextStyle(color: Colors.red)),
                ),
              )
          ],
        ),
        ),
      ),
    );
  }
}


