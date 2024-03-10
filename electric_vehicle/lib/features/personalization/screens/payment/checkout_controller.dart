import 'package:electric_vehicle/common/widgets/heading/section_heading.dart';
import 'package:electric_vehicle/common/widgets/list_tile/payment_tile.dart';
import 'package:electric_vehicle/features/personalization/screens/payment/payment_method_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  final Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel.empty().obs;

  @override
  void onInit() {
    selectedPaymentMethod.value = PaymentMethodModel(name: 'VISA', image: EVImages.visaCard);
    super.onInit();
  }

  Future<dynamic> selectPaymentMethod(BuildContext context){
    return showModalBottomSheet(
        context: context,
        builder: (_) => SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(EVSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EVSectionHeading(title: 'Select Payment Method', showActionButton: false,),
                const SizedBox(height: EVSizes.spaceBtwSections),
                PaymentTile(paymentMethod: PaymentMethodModel(name: 'Credit Card', image: EVImages.creditCard),),
                const SizedBox(height: EVSizes.spaceBtwItems/2),
                PaymentTile(paymentMethod: PaymentMethodModel(name: 'Master Card', image: EVImages.masterCard),),
                const SizedBox(height: EVSizes.spaceBtwItems/2),
                PaymentTile(paymentMethod: PaymentMethodModel(name: 'VISA', image: EVImages.visaCard),),
                const SizedBox(height: EVSizes.spaceBtwItems/2),
              ],
            ),
          ),
        ),
    );
  }
}
