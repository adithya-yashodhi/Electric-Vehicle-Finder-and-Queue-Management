import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electric_vehicle/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:electric_vehicle/features/authentication/screens/home/home.dart';
import 'package:electric_vehicle/features/authentication/screens/reservation/payment_success.dart';
import 'package:electric_vehicle/features/authentication/screens/station/widgets/station_meta_data.dart';
import 'package:electric_vehicle/features/personalization/screens/payment/billing_amount_section.dart';
import 'package:electric_vehicle/features/personalization/screens/payment/billing_payment_section.dart';
import 'package:electric_vehicle/features/personalization/screens/vehicle/widgets/vehicle_section.dart';
import 'package:electric_vehicle/utils/popups/loaders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../personalization/screens/vehicle/controller/vehicle_controller.dart';

class ConfirmScreen extends StatelessWidget {
  ConfirmScreen({
    super.key,
    required this.selectedDate,
    required this.selectedSlot,
    required this.selectedPort,
    required this.stationData,
    required this.portCharge,
  });

  final DateTime selectedDate;
  final String selectedSlot;
  final String selectedPort;
  final Map<String, dynamic> stationData;
  final double portCharge;
  late double total; // Variable to hold the total

  @override
  Widget build(BuildContext context) {
    final dark = EVHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('Confirmation',
              style: Theme.of(context).textTheme.headlineMedium)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(EVSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                width: EVHelperFunctions.screenWidth() * 0.8,
                height: EVHelperFunctions.screenHeight() * 0.4,
                image: const AssetImage(EVImages.confirm),
              ),
              Text('Booking Information',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: EVSizes.spaceBtwItems),
              Row(
                children: [
                  Text('Selected Date: ',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(width: EVSizes.spaceBtwItems),
                  Text('$selectedDate'),
                ],
              ),
              const SizedBox(height: EVSizes.spaceBtwItems),
              Row(
                children: [
                  Text('Selected Time Slot: ',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(width: EVSizes.spaceBtwItems),
                  Text(selectedSlot),
                ],
              ),
              const SizedBox(height: EVSizes.spaceBtwItems),
              Row(
                children: [
                  Text('Selected Port: ',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(width: EVSizes.spaceBtwItems),
                  Text(selectedPort),
                ],
              ),
              const SizedBox(height: EVSizes.spaceBtwSections / 2),
              const Divider(),
              const SizedBox(height: EVSizes.spaceBtwItems),
              const VehicleSection(),
              const SizedBox(height: EVSizes.spaceBtwSections),
              EVRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(EVSizes.md),
                backgroundColor: dark ? EVColors.dark : EVColors.light,
                child: Column(
                  children: [
                    BillingAmountSection(
                      selectedPort: portCharge.toString(),
                      // Callback function to receive the total
                      onTotalCalculated: (calculatedTotal) {
                        total = calculatedTotal;
                      },
                    ),
                    const SizedBox(height: EVSizes.spaceBtwItems),
                    const Divider(),
                    const SizedBox(height: EVSizes.spaceBtwItems),
                    const BillingPaymentSection(),
                    const SizedBox(height: EVSizes.spaceBtwItems),
                  ],
                ),
              ),
              const SizedBox(height: EVSizes.spaceBtwSections),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            final vehicleController =
                                Get.find<VehicleController>();
                            final selectedVehicle =
                                vehicleController.selectedVehicle.value;
                            if (selectedVehicle == null ||
                                selectedVehicle.id.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('No vehicle selected')),
                              );
                            } else {
                              _confirmReservation(context);
                              Get.to(() => const PaymentSuccessScreen());
                            }
                          },
                          child: const Text('Confirm'))),
                  const SizedBox(width: EVSizes.spaceBtwInputFields),
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(Get.context!).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.red)))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmReservation(BuildContext context) async {
    try {
      final authUser = AuthenticationRepository.instance.authUser;

      if (authUser == null) {
        throw 'User is not authenticated';
      }

      final vehicleController = Get.find<VehicleController>();
      final selectedVehicle = vehicleController.selectedVehicle.value;

      // final stationDocRef = FirebaseFirestore.instance.collection('Stations').doc(stationData['Id']);
      //
      // await stationDocRef.collection('SlotAvailability').doc(selectedDate.toString()).set({
      //   'booked': true,
      //   'Slot': selectedSlot,
      //   'Date': selectedDate,
      //   'VehicleModel': selectedVehicle.vehicleModel,
      //   'VehicleNumber': selectedVehicle.vehicleNumber,
      //   // Add other data related to the reservation
      // });

      final stationCollection = FirebaseFirestore.instance
          .collection('Stations')
          .doc(stationData['Id'])
          .collection('SlotAvailability');

      // Format the selected date
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      // Create a new document for the booking
      await stationCollection.add({
        'Date': Timestamp.fromDate(selectedDate),
        'Slot': selectedSlot,
        'booked': true,
        'VehicleModel': selectedVehicle.vehicleModel,
        'VehicleNumber': selectedVehicle.vehicleNumber,
        'TotalAmount': total,
        // Add any other relevant data here
      });

      // Store reservation data in Firestore
      await FirebaseFirestore.instance
          .collection('Users/${authUser.uid}/Booking')
          .add({
        'StationName': stationData["StationName"],
        'StationAddress': stationData['StationAddress'],
        'StationPhoneNumber': stationData['PhoneNumber'],
        'SelectedDate': selectedDate,
        'SelectedTimeSlot': selectedSlot,
        'SelectedPort': selectedPort,
        'Longitude': stationData["Latitude"],
        'Latitude': stationData["Longitude"],
        'Vehicle Number': selectedVehicle.vehicleNumber,
      });

      EVLoaders.successSnackBar(title: 'Confirm Successfully!');
    } catch (error, stackTrace) {
      // Handle any errors that occur during the reservation process
      if (kDebugMode) {
        print('Error confirming reservation: $error');
        print(stackTrace);
      }
      // You can also display an error message to the user
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Error confirming reservation. Please try again later.')),
      // );
    }
  }
}
