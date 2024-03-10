import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electric_vehicle/features/authentication/screens/home/admin/report.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../common/widgets/custom_shapes/container/primary_header_container.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../personalization/screens/admin_reservation/admin_reservation.dart';
import '../../admin_station/controller/station_controller.dart';
import 'admin_home_appbar.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StationController());
    final station = controller.station.value;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const EVPrimaryHeaderContainer(
              child: Column(
                children: [
                  EVAdminHomeAppBar(),
                  SizedBox(height: EVSizes.spaceBtwSections),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(EVSizes.defaultSpace),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF269E66), // Background color
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Today Reservations',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .apply(color: Colors.white)),
                            ],
                          ),
                        ),
                        const SizedBox(height: EVSizes.spaceBtwSections),
                        StreamBuilder<QuerySnapshot>(
                            stream: station.id != null && station.id.isNotEmpty ?
                            FirebaseFirestore.instance
                                .collection('Stations')
                                .doc(station.id)
                                .collection('SlotAvailability')
                                .snapshots() : null,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                                // Handle the case where snapshot data is null, maybe show an error message or return early
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                // Filter documents by today's date
                                final todayDateTime = DateTime.now();
                                final todayFormatted = DateFormat('dd MMM yyyy')
                                    .format(todayDateTime);
                                if (kDebugMode) {
                                  print(
                                      'Data Length: ${snapshot.data?.docs.length}');
                                }
                                int reservationCount = 0;
                                snapshot.data!.docs.forEach((doc) {
                                  // Convert Timestamp to DateTime
                                  final docDateTime =
                                      (doc['Date'] as Timestamp).toDate();
                                  final docFormatted = DateFormat('dd MMM yyyy')
                                      .format(docDateTime);
                                  if (docFormatted == todayFormatted) {
                                    reservationCount++;
                                  }
                                });
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$reservationCount',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 50.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(
                                          EVSizes.defaultSpace),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            // Set the width to occupy the entire available space
                                            child: OutlinedButton(
                                              onPressed: () => Get.to(() =>
                                                  const AdminReservationScreen()),
                                              child: const Text('View',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(height: EVSizes.spaceBtwSections),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        // Add border around the container
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.all(EVSizes.defaultSpace),
                    child: Column(
                      children: [
                        Image.asset(
                          EVImages.reportIcon,
                          width: 70, // Adjust width as needed
                          height: 70, // Adjust height as needed
                        ),
                        const SizedBox(height: EVSizes.spaceBtwSections / 2),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final result = await getTotalEarnings();
                              final totalEarnings =
                                  result['totalEarnings'] as double;
                              final todayReservations =
                                  result['todayReservations']
                                      as List<Map<String, dynamic>>;
                              navigateToReportScreen(
                                  totalEarnings, todayReservations);
                            },
                            child: const Text('Generate Report'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, Object>> getTotalEarnings() async {
    final controller = Get.put(StationController());
    final station = controller.station.value;

    // Filter documents by today's date
    final todayDateTime = DateTime.now();
    final todayFormatted = DateFormat('dd MMM yyyy').format(todayDateTime);

    double totalEarnings = 0.0;
    List<Map<String, dynamic>> todayReservations = [];

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Stations')
          .doc(station.id)
          .collection('SlotAvailability')
          .get();

      if (kDebugMode) {
        print('Snapshot length: ${snapshot.docs.length}');
      }

      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final date = (doc['Date'] as Timestamp)
              .toDate(); // Assuming 'date' field is a Timestamp
          final docFormatted = DateFormat('dd MMM yyyy').format(date);
          if (docFormatted == todayFormatted) {
            final totalAmount = doc['TotalAmount'];
            if (totalAmount != null) {
              totalEarnings += double.parse(
                  totalAmount.toString()); // Add TotalAmount to totalEarnings
              final vehicleNumber = data['VehicleNumber'];
              todayReservations.add(
                  {'VehicleNumber': vehicleNumber, 'TotalAmount': totalAmount});
            } else {
              if (kDebugMode) {
                print('TotalAmount is null in document: ${doc.id}');
              }
            }
          }
        });
        if (kDebugMode) {
          print('Total Earnings: $totalEarnings');
        }
      } else {
        if (kDebugMode) {
          print('No reservations for today');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching total earnings: $e');
      } // Print error if any
    }
    return {
      'totalEarnings': totalEarnings,
      'todayReservations': todayReservations
    };
  }

  void navigateToReportScreen(
      double totalEarnings, List<Map<String, dynamic>> todayReservations) {
    Get.to(() => ReportScreen(
        totalEarnings: totalEarnings, todayReservations: todayReservations));
  }
}
