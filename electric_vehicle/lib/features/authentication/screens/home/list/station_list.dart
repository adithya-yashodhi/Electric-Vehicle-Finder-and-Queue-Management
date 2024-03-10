import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class EVStationListItems extends StatelessWidget {
  const EVStationListItems(
      {super.key, required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) =>
      const SizedBox(height: EVSizes.spaceBtwItems),
      itemBuilder: itemBuilder,
    );
  }
}
