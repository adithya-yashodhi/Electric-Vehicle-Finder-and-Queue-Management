import 'package:electric_vehicle/common/widgets/appbar/appbar.dart';
import 'package:electric_vehicle/features/personalization/screens/myBooking/my_booking_list.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class MyBooking extends StatelessWidget {
  const MyBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// -- Appbar
      appBar: EVAppBar(title: Text('My Booking', style: Theme.of(context).textTheme.headlineSmall), showBackArrow: true,),
      body: const Padding(
        padding: EdgeInsets.all(EVSizes.defaultSpace),

        /// --bookings
        child: MyBookingListItems(),
      ),
    );
  }
}
