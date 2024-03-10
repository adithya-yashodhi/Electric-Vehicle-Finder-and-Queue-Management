import 'package:electric_vehicle/features/authentication/screens/home/home.dart';
import 'package:electric_vehicle/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EVSpacingStyle.paddingWithAppBarHeight * 2,
        child: Column(
          children: [
            ///Image
            Image(width: MediaQuery.of(context).size.width * 0.6,
              image: const AssetImage(EVImages.paymentSuccess),),
            const SizedBox(height: EVSizes.spaceBtwItems),

            /// title and subtitle
            Text('Payment Success!', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: EVSizes.spaceBtwItems),
            Text('Your Payment Successful! Please Come on time to power up your vehicle.', style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
            const SizedBox(height: EVSizes.spaceBtwItems),

            /// buttons
            SizedBox(width: double.infinity,
              child: ElevatedButton(onPressed: () => Get.to(() => const NavigationMenu()), child: const Text(EVTexts.evContinue)),
            ),
          ],
        ),
      ),
    );
  }
}
