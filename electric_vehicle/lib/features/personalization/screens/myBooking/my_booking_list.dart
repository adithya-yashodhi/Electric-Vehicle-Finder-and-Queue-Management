import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electric_vehicle/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:electric_vehicle/utils/constants/colors.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:electric_vehicle/utils/helpers/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';

class MyBookingListItems extends StatelessWidget {
  const MyBookingListItems({super.key});

  void _launchMaps(double? lat, double? lng) async {
    if (lat != null && lng != null) {
      final uri = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        throw 'Could not launch $uri';
      }
    } else {
      if (kDebugMode) {
        print('Latitude or longitude is null');
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final dark = EVHelperFunctions.isDarkMode(context);

    final authUser = AuthenticationRepository.instance.authUser;

    if (authUser == null) {
      throw 'User is not authenticated';
    }

    return StreamBuilder(
      stream:  FirebaseFirestore.instance
          .collection('Users')
          .doc(authUser.uid)
          .collection('Booking')
          .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        // Separate upcoming and finished bookings
        final upcomingBookings = <Widget>[];
        final finishedBookings = <Widget>[];

    snapshot.data!.docs.forEach((DocumentSnapshot document) {
      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      final currentDate = DateTime.now();

      final selectedDate = (data['SelectedDate'] as Timestamp).toDate();
      final selectedTimeSlot = data['SelectedTimeSlot'].toString();

      final List<String> times = selectedTimeSlot.split("-");

      final startTime = times[0].trim();
      final endTime = times[1].trim();

      final selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        int.parse(startTime.split('.')[0]),
        int.parse(endTime.split('.')[1]),
      );

      // Check if the selected date and time slot have passed
      final isFinished = currentDate.isAfter(selectedDateTime);



      final bookingWidget = EVRoundedContainer(
              showBorder: true,
              padding: const EdgeInsets.all(EVSizes.md),
              backgroundColor: dark ? EVColors.dark : EVColors.light,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// Row 1
                  Row(
                    children: [

                      /// 1 - Icon
                      const Icon(Iconsax.calendar),
                      const SizedBox(width: EVSizes.spaceBtwItems),

                      /// 2 date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isFinished ? 'Finished' : 'Upcoming',
                              style: Theme.of(context).textTheme.bodyLarge!.apply(color: EVColors.primary,
                                  fontWeightDelta: 1),
                            ),
                            Text(DateFormat('dd MMM yyyy').format(data['SelectedDate'].toDate()),
                              style: Theme.of(context).textTheme.headlineSmall)
                          ],
                        ),
                      ),

                      /// 3 -icon
                      IconButton(
                        onPressed: () {
                          final latitude =
                          data["Latitude"];
                          final longitude =
                          data["Longitude"];

                          if (latitude != null &&
                              longitude != null) {
                            _launchMaps(
                                double.parse(latitude
                                    .toString()),
                                double.parse(longitude
                                    .toString()));
                          } else {
                            if (kDebugMode) {
                              print(
                                  "Latitude or longitude is null");
                            }
                          }
                        },
                        icon: const Icon(
                            Icons.directions,
                            size: EVSizes.iconLg,
                            color: Color(0xff269E66)),
                      ),
                    ],
                  ),
                  const SizedBox(height: EVSizes.spaceBtwItems,),

                  /// -- row 2
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [

                            /// 1 - Icon
                            const Icon(Iconsax.clock),
                            const SizedBox(width: EVSizes.spaceBtwItems / 2),

                            /// 2 date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Time', style: Theme.of(context).textTheme.labelMedium),
                                  Text(data['SelectedTimeSlot'], style: Theme.of(context).textTheme.titleMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 55),
                      Expanded(
                        child: Row(
                          children: [

                            /// 1 - Icon
                            const Icon(Iconsax.car),
                            const SizedBox(width: EVSizes.spaceBtwItems / 2),

                            /// 2 date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Vehicle No', style: Theme.of(context).textTheme.labelMedium),
                                  Text(data['Vehicle Number'], style: Theme.of(context).textTheme.titleMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
      // Add the booking to the appropriate list
      if (isFinished) {
        finishedBookings.add(bookingWidget);
      } else {
        upcomingBookings.add(bookingWidget);
      }
          });
        // Concatenate the lists to display upcoming bookings first
        final allBookings = [...upcomingBookings, ...finishedBookings];

        return ListView.separated(
          shrinkWrap: true,
          //physics: const NeverScrollableScrollPhysics(),
          itemCount: allBookings.length,
          separatorBuilder: (_, __) => const SizedBox(height: EVSizes.spaceBtwItems),
          itemBuilder: (_, index) => allBookings[index],
        );
      }
    },
    );
  }
}
