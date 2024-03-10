import 'package:electric_vehicle/features/authentication/screens/station/widgets/rating_share_direction_widget.dart';
import 'package:electric_vehicle/features/authentication/screens/station/widgets/station_detail_image.dart';
import 'package:electric_vehicle/features/authentication/screens/station/widgets/station_meta_data.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class StationDetail extends StatelessWidget {
  const StationDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// image slider
            EVStationImage(),

            /// station detail
            Padding(
              padding: EdgeInsets.only(
                  right: EVSizes.defaultSpace,
                  left: EVSizes.defaultSpace,
                  bottom: EVSizes.defaultSpace),
              child: Column(
                /// rating & share button
                children: [
                  EvRatingShareAndDirection(),
                  //EVStationMetaData(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
