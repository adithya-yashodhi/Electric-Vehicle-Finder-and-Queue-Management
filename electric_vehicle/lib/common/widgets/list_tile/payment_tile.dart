import 'package:electric_vehicle/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:electric_vehicle/features/personalization/screens/payment/checkout_controller.dart';
import 'package:electric_vehicle/features/personalization/screens/payment/payment_method_model.dart';
import 'package:electric_vehicle/utils/constants/colors.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:electric_vehicle/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PaymentTile extends StatelessWidget {
  const PaymentTile({super.key, required this.paymentMethod});

  final PaymentMethodModel paymentMethod;

  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: () {
        controller.selectedPaymentMethod.value = paymentMethod;
        Get.back();
      },
      leading: EVRoundedContainer(
        width: 60,
        height: 40,
        backgroundColor: EVHelperFunctions.isDarkMode(context) ? EVColors.light : EVColors.white,
        padding: const EdgeInsets.all(EVSizes.sm),
        child: Image(
          image: AssetImage(paymentMethod.image),
          fit: BoxFit.contain,
        ),
      ),
      title: Text(paymentMethod.name),
      trailing: const Icon(Iconsax.arrow_right_34),
    );
  }
}
