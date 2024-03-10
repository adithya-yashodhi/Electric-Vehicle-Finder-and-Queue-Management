import 'package:electric_vehicle/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:electric_vehicle/common/widgets/heading/section_heading.dart';
import 'package:electric_vehicle/features/personalization/screens/payment/checkout_controller.dart';
import 'package:electric_vehicle/features/personalization/screens/payment/payment_method_model.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

class BillingPaymentSection extends StatelessWidget {
  const BillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(CheckoutController());
    final dark = EVHelperFunctions.isDarkMode(context);

    return Column(
      children: [
        EVSectionHeading(title: 'PaymentMethod', buttonTitle: 'Change', onPressed: () => controller.selectPaymentMethod(context)),
        const SizedBox(height: EVSizes.spaceBtwItems / 2),
        Obx(
          () => Row(
            children: [
              EVRoundedContainer(
                width: 60,
                height: 35,
                backgroundColor: dark ? EVColors.light : EVColors.white,
                padding: const EdgeInsets.all(EVSizes.sm),
                child: Image(image: AssetImage(controller.selectedPaymentMethod.value.image), fit: BoxFit.contain,),
              ),
              const SizedBox(width: EVSizes.spaceBtwItems/2,),
              Text(controller.selectedPaymentMethod.value.name, style: Theme.of(context).textTheme.bodyLarge,),
            ],
          ),
        )
      ],
    );
  }
}
