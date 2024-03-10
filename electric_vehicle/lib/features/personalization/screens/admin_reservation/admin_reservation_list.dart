import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electric_vehicle/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:electric_vehicle/utils/constants/colors.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:electric_vehicle/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminReservationListItems extends StatefulWidget {
  const AdminReservationListItems({super.key, required this.stationId});

  final String stationId;

  @override
  State<AdminReservationListItems> createState() =>
      _AdminReservationListItemsState();
}

class _AdminReservationListItemsState extends State<AdminReservationListItems> {
  late DateTime _selectedDate;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<dynamic>> _events;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _events = {};
  }

  @override
  Widget build(BuildContext context) {

    final dark = EVHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2022, 1, 1),
          lastDay: DateTime.utc(2025, 12, 31),
          focusedDay: _selectedDate,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDate, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
            });
          },
          headerStyle: const HeaderStyle(
            formatButtonVisible: false, // Hide the format button
            titleTextStyle: TextStyle(fontSize: 20), // Customize the title text style
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            //   color: const Color(0xFF269E66), // Set header background color
            // ),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
            weekendStyle: TextStyle(
                color: Colors.red,
                fontWeight:
                    FontWeight.bold), // Customize weekend days text style
          ),
          calendarStyle: CalendarStyle(
            defaultTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold), // Customize default day text style
            selectedDecoration: const BoxDecoration(
              color: Colors.green, // Set selected day background color
              shape: BoxShape.circle, // Make the selected day a circle
            ),

            todayTextStyle: const TextStyle(
                fontWeight: FontWeight.bold), // Customize today's text style

            todayDecoration: BoxDecoration(
              color: Colors.transparent, // Transparent background color
              border: Border.all(
                color: const Color(0xFF269E66), // Outline color
                width: 2, // Outline width
              ),
              shape: BoxShape.circle, // Make today's decoration a rectangle
            ),
            weekendTextStyle: const TextStyle(
                color: Colors.red,
                fontWeight:
                    FontWeight.bold), // Customize weekend days text style
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Stations')
                .doc(widget.stationId)
                .collection('SlotAvailability')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // Separate upcoming and finished bookings
                final bookings = <Widget>[];

                snapshot.data!.docs.forEach((DocumentSnapshot document) {
                  final Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  final selectedDate = (data['Date'] as Timestamp).toDate();
                  final currentDate = DateTime.now();
                  final isFinished = currentDate.isAfter(selectedDate);
                  if (isSameDay(selectedDate, _selectedDate)) {
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .apply(
                                              color: EVColors.primary,
                                              fontWeightDelta: 1),
                                    ),
                                    Text(
                                        DateFormat('dd MMM yyyy')
                                            .format(data['Date'].toDate()),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: EVSizes.spaceBtwItems,
                          ),

                          /// -- row 2
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    /// 1 - Icon
                                    const Icon(Iconsax.clock),
                                    const SizedBox(
                                        width: EVSizes.spaceBtwItems / 2),

                                    /// 2 date
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Time',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium),
                                          Text(data['Slot'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium),
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
                                    const SizedBox(
                                        width: EVSizes.spaceBtwItems / 2),

                                    /// 2 date
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Vehicle No',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium),
                                          Text(data['VehicleNumber'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium),
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
                    bookings.add(bookingWidget);
                  }
                });
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: bookings.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: EVSizes.spaceBtwItems),
                  itemBuilder: (_, index) => bookings[index],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
