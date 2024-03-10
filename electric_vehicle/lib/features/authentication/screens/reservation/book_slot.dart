import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utils/constants/sizes.dart';
import 'confirm_page.dart';
import 'package:google_fonts/google_fonts.dart';

class AddReservationPage extends StatefulWidget {
  const AddReservationPage({Key? key, required this.ports, required this.stationData, required this.portsData}) : super(key: key);

  final List<String> ports;
  final List<Map<String, dynamic>> portsData;
  final Map<String, dynamic> stationData;
  @override
  State<AddReservationPage> createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {

  // String? stationId;
  late DateTime selectedDate;
  String? selectedSlot;
  String? selectedPort;
  List<String> bookedSlots = [];
  List<String> availableSlots = [];

  final Set<String> TIME_SLOT_1 = {
    '08.30-13.30',
    '13.30-18.30',
  };

  final Set<String> TIME_SLOT_2 = {
    '08.30-10.30',
    '10.30-12.30',
    '12.30-14.30',
    '14.30-16.30',
    '16.30-18.30',
  };

  final Set<String> TIME_SLOT_3 = {
    '08.30-09.30',
    '09.30-10.30',
    '10.30-11.30',
    '11.30-12.30',
    '12.30-13.30',
    '14.30-15.30',
    '15.30-16.30',
    '16.30-17.30',
    '17.30-18.30',
  };

  final Set<String> TIME_SLOT_4 = {
    '08.30-09.00',
    '09.00-09.30',
    '09.30-10.00',
    '10.00-10.30',
    '10.30-11.00',
    '11.00-11.30',
    '11.30-12.00',
    '12.00-12.30',
    '12.30-13.00',
    '13.00-13.30',
    '13.30-14.00',
    '14.00-14.30',
    '14.30-15.00',
    '15.00-15.30',
    '15.30-16.00',
    '16.00-16.30',
    '16.30-17.00',
    '17.00-17.30',
    '17.30-18.00',
    '18.00-18.30',
  };


  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    fetchBookedSlots(selectedDate);
  }

  Future<void> fetchBookedSlots(DateTime selectedDate) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    if (kDebugMode) {
      print('Fetching slots for date: $formattedDate, stationId: ${widget.stationData['Id']}');
    }

    try {
      if (kDebugMode) {
        print('Fetching slots...');
      }
      final snapshot = await FirebaseFirestore.instance
          .collection('Stations')
          .doc(widget.stationData['Id'])
          .collection('SlotAvailability')
          .get();

      if (kDebugMode) {
        print('Number of documents retrieved: ${snapshot.docs.length}');
      }

      if (kDebugMode) {
        print('Processing snapshot...');
      }
      final List<String> booked = [];
      final List<String> available = [];

      snapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final date = data['Date'] as Timestamp; // Assuming 'date' field is a Timestamp

        // Convert Timestamp to DateTime
        final docDate = DateTime.fromMillisecondsSinceEpoch(
            date.millisecondsSinceEpoch);

        if (DateFormat('yyyy-MM-dd').format(docDate) == formattedDate) {
          if (kDebugMode) {
            print('Found matching date: $formattedDate');
          }
          final slot = data['Slot'] as String;
          if (data['booked'] == true) {
            booked.add(slot);
          }
            else {
            available.add(slot);
          }
        }
      });

      setState(() {
        bookedSlots = booked;
        //availableSlots = available;
      });

      if (kDebugMode) {
        print('Slots fetched successfully.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching slots: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reservations',
          style: Theme
              .of(context)
              .textTheme
              .headlineSmall,
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 150,
            child: Container(
              color: const Color(0xFF269E66),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.MMMM().format(selectedDate),
                        style: GoogleFonts.robotoMono(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        '${selectedDate.day}',
                        style: GoogleFonts.robotoMono(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        DateFormat.EEEE().format(selectedDate),
                        style: GoogleFonts.robotoMono(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: EVSizes.spaceBtwItems),
          SizedBox(
            width: 200,
            child : DropdownButtonFormField<String>(
              value: selectedPort,
              hint: const Text('Select Port'),
              isExpanded: true,
              decoration: const InputDecoration(
                hintText: 'Select Port',
              ),
              items: widget.ports.map((port) {
                return DropdownMenuItem<String>(
                  value: port,
                  child: Text(port),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPort = value;
                  selectedSlot = null;
                });
              },
            ),
          ),

          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: getTimeSlotCount(selectedPort),
              itemBuilder: (context, index) {
                String slot = getTimeSlot(selectedPort, index);
                bool isBooked = bookedSlots.contains(slot);
                bool isSelected = selectedSlot == slot;

                return GestureDetector(
                  onTap: () {
                    if (!isBooked) {
                      _selectSlot(slot);
                    }
                    //bookedSlots.contains(slot) ? null : () => _selectSlot(slot);
                  },
                  child: Card(
                    //bookedSlots.contains(slot) ? Colors.red : Colors.green,
                    color: isBooked ? Colors.grey : isSelected ? const Color(
                        0xFF269E66) : Colors.white,
                    child: GridTile(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              slot,
                              style: TextStyle(
                                color: isBooked || isSelected
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              isBooked ? 'Booked' : 'Available',
                              style: GoogleFonts.robotoMono(
                                color: isSelected ? Colors.white : Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedPort != null) {

                    if (selectedSlot != null) {
                      confirmReservation(selectedDate, selectedSlot!);
                    } else {
                      // Handle case where slot is not selected
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a time slot.'),
                          ),
                      );
                    }
                  } else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a port.'),
                      ),
                    );
                  }
                },
                child: const Text('Next'),
              ),
            ),
            const SizedBox(width: EVSizes.spaceBtwInputFields),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(Get.context!).pop();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text(
                    'Cancel', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        // Refresh booked slots for the newly selected date
        fetchBookedSlots(selectedDate);
        if (selectedSlot != null && !availableSlots.contains(selectedSlot)) {
          selectedSlot = null;
        }
      });
    }
  }

  void _selectSlot(String slot) {
    DateTime now = DateTime.now();

    // Check if the selected date is the current date
    bool isCurrentDate = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;


    // Print selected time slot and current time
    print('Selected Time Slot: $slot');
    print('Current Time: $now');

    // Check if the selected time slot is in the future or the current time
    if (isCurrentDate) {
      // Extract the hours and minutes from the selected time slot
      List<String> slotParts = slot.split('-');
      String startTimeString = slotParts[0].trim();
      List<String> startTimeParts = startTimeString.split('.');
      int selectedHour = int.parse(startTimeParts[0]);
      int selectedMinute = int.parse(startTimeParts[1]);

        if ((selectedHour > now.hour) ||
            (selectedHour == now.hour && selectedMinute >= now.minute)) {
      if (!bookedSlots.contains(slot)) {
        setState(() {
          selectedSlot = slot;
        });
        print('Time slot selected: $slot');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selected slot is already booked. Please choose another slot.'),
          ),
        );
        print('Selected slot is already booked.');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selected time has already passed. Please choose another slot."),
        ),
      );
      print('Selected time slot is not in the future or the current time.');
    }
  }else {
      // For future dates, directly set the selected slot without any time checking
      setState(() {
        selectedSlot = slot;
      });
    }
  }


  int getTimeSlotCount(String? selectedPort) {
    switch(selectedPort) {
      case 'Type1':
        return TIME_SLOT_1.length;
      case 'Type2':
        return TIME_SLOT_2.length;
      case 'CHADeMO':
        return TIME_SLOT_3.length;
      case 'SuperCharger':
        return TIME_SLOT_4.length;
      default:
        return 0;
    }
  }

  String getTimeSlot(String? selectedPort, int index) {
    switch(selectedPort) {
      case 'Type1':
        return TIME_SLOT_1.elementAt(index);
      case 'Type2':
        return TIME_SLOT_2.elementAt(index);
      case 'CHADeMO':
        return TIME_SLOT_3.elementAt(index);
      case 'SuperCharger':
        return TIME_SLOT_4.elementAt(index);
      default:
        return '';
    }
  }


  void confirmReservation(DateTime selectedDate, String selectedSlot) async {
    if (kDebugMode) {
      print('Confirm reservation called.');
    }
    final stationData = widget.stationData;

    Map<String, dynamic>? selectedPortData;
    for (Map<String, dynamic> portData in widget.portsData) {
      if (portData['PortType'] == selectedPort) {
        selectedPortData = portData;
        break;
      }
    }

    if (selectedPortData != null) {
      if (kDebugMode) {
        print('Selected port data found.');
      }
      // Extract the price from the selected port data
      String priceString = selectedPortData['Price'] ?? '0.0'; // Assume '0.0' as default value if Price is null
      double price = double.parse(priceString);

      // Navigate to confirmation screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ConfirmScreen(
                selectedDate: selectedDate,
                selectedSlot: selectedSlot,
                selectedPort: selectedPort!,
                stationData: stationData,
                portCharge: price,
              ),
        ),
      );
    }
  }
}
