import 'package:flutter/material.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/pricing_calculator.dart';

class BillingAmountSection extends StatelessWidget {
  const BillingAmountSection({super.key, required this.selectedPort, required this.onTotalCalculated});

  final String selectedPort;
  final void Function(double total) onTotalCalculated;

  @override
  Widget build(BuildContext context) {

    final portCharge = double.parse(selectedPort);
    final subTotal = portCharge;
    final tax = double.parse(EVPricingCalculator.calculateTax(subTotal, selectedPort));
    final total = EVPricingCalculator.calculateTotalPrice(subTotal, selectedPort);

    // Pass the total to the callback function
    onTotalCalculated(total);

    return Column(
      children: [

        /// subTotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Port Charge', style: Theme.of(context).textTheme.bodyMedium),
            Text('$portCharge LKR', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: EVSizes.spaceBtwItems / 2),

        /// tax
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tax', style: Theme.of(context).textTheme.bodyMedium),
            Text('$tax LKR', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: EVSizes.spaceBtwItems / 2),

        /// total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: Theme.of(context).textTheme.bodyMedium),
            Text('$total LKR', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ],
    );
  }
}
