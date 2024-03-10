import 'package:electric_vehicle/features/authentication/screens/map/current_location.dart';
import 'package:electric_vehicle/features/authentication/screens/map/widgets/map_appbar.dart';
import 'package:flutter/material.dart';
import '../../../../common/widgets/custom_shapes/container/primary_header_container.dart';
import '../../../../utils/constants/sizes.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          EVPrimaryHeaderContainer(
            child: Column(
              children: [
                EVMapAppBar(),
                SizedBox(height: EVSizes.spaceBtwItems),
              ],
            ),
          ),
          Expanded(child: CurrentLocationScreen()),
        ],
      ),
    );
  }
}
