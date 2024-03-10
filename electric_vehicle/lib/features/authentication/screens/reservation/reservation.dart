import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/popups/loaders.dart';

class AddReservation extends StatefulWidget {
  final String stationId;
  final List<String> ports;
  const AddReservation({Key? key, required this.stationId, required this.ports}) : super(key: key);

  @override
  State<AddReservation> createState() => _AddReservationState();
}

class _AddReservationState extends State<AddReservation> {
  late DateTime selectedDate;
  String? selectedSlot;
  String? selectedPort;
  List<String> bookedSlots = [];
  List<String> availableSlots = [];

  final Set<String> TIME_SLOTS = {
    '08:00 AM',
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  };

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    fetchBookedSlots(selectedDate);
    //refreshBookedSlots();
  }

  Future<void> fetchBookedSlots(DateTime selectedDate) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    try {
      print('Fetching slots...');
      final snapshot = await FirebaseFirestore.instance
          .collection('Stations')
          .doc(widget.stationId)
          .collection('SlotAvailability')
          .get();

      print('Processing snapshot...');
      final List<String> booked = [];
      final List<String> available = [];

      snapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final date = data['date'] as Timestamp; // Assuming 'date' field is a Timestamp

        // Convert Timestamp to DateTime
        final docDate = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);

        if (DateFormat('yyyy-MM-dd').format(docDate) == formattedDate) {
          print('Found matching date: $formattedDate');
          final slot = data['slot'] as String;
          if (data['booked'] == true) {
            booked.add(slot);
          } else {
            available.add(slot);
          }
        }
      });

      setState(() {
        bookedSlots = booked;
        //availableSlots = available;
      });

      print('Slots fetched successfully.');

    } catch (e) {
      print('Error fetching slots: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reservation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Station ID: ${widget.stationId}', // Auto-filled station ID
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Port:',
                style: TextStyle(fontSize: 16),
              ),
              DropdownButton<String>(
                value: selectedPort,
                onChanged: (value) {
                  setState(() {
                    selectedPort = value;
                  });
                },
                items: widget.ports.map((port) {
                  return DropdownMenuItem<String>(
                    value: port,
                    child: Text(port),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Date:',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text(DateFormat('MM/dd/yyyy').format(selectedDate)),
              ),
              const SizedBox(height: 20),
              const Text(
                'Booked Slots:',
                style: TextStyle(fontSize: 16),
              ),
              Wrap(
                spacing: 10,
                children: bookedSlots.map((slot) {
                  return ElevatedButton(
                    onPressed: null,
                    child: Text(slot),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                  );
                }).toList(),
              ),
              const Text(
                'Select Time Slot:',
                style: TextStyle(fontSize: 16),
              ),
              Wrap(
                spacing: 10,
                children: TIME_SLOTS.map((slot) {
                  return ElevatedButton(
                    onPressed: bookedSlots.contains(slot) ? null : () => _selectSlot(slot),
                    child: Text(slot),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        bookedSlots.contains(slot) ? Colors.red : Colors.green,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              if (selectedSlot != null) ...[
                const Text(
                  'Enter Your Name:',
                  style: TextStyle(fontSize: 16),
                ),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _confirm();
                  _confirmReservation(context);
                },
                child: const Text('Confirm Reservation'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)), // Allowing selection up to 30 days from now
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        // Refresh booked slots for the newly selected date
        fetchBookedSlots(selectedDate);
      });
    }
  }

  void _selectSlot(String slot) {
    setState(() {
      selectedSlot = slot;
    });
  }

  void _confirm() async {

    final stationId = widget.stationId;
    final stationDocRef = FirebaseFirestore.instance.collection('Stations').doc(stationId);


    await stationDocRef.collection('SlotAvailability').doc(selectedDate.toString()).set({
      'booked': true,
      'slot': selectedSlot,
      'date': selectedDate,
      // Add other data related to the reservation
    });
  }

  void _confirmReservation(BuildContext context) async {
    try {
      final authUser = AuthenticationRepository.instance.authUser;

      if (authUser == null) {
        throw 'User is not authenticated';
      }

      // Store reservation data in Firestore
      await FirebaseFirestore.instance.collection('Users/${authUser.uid}/MyBooking').add({
        'selectedDate': selectedDate,
        'selectedTimeSlot': selectedSlot,
        'selectedPort': selectedPort,
      });

      // Navigate back to the previous screen
      Navigator.of(Get.context!).pop();
      EVLoaders.successSnackBar(title: 'Confirm Successfully!');
    } catch (error) {
      // Handle any errors that occur during the reservation process
      print('Error confirming reservation: $error');
      // You can also display an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error confirming reservation. Please try again later.')),
      );
    }
  }
}
