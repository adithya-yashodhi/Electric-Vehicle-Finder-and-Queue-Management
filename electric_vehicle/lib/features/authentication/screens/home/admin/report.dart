import 'package:electric_vehicle/features/authentication/screens/admin_station/controller/station_controller.dart';
import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import '../../../../../common/widgets/appbar/appbar.dart';
import 'package:printing/printing.dart';

class ReportScreen extends StatelessWidget {
  final double totalEarnings;
  final List<Map<String, dynamic>> todayReservations;

  const ReportScreen(
      {Key? key, required this.totalEarnings, required this.todayReservations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(StationController());
    final station = controller.station.value;
    final now = DateTime.now();

    List<List<dynamic>> tableData = [];

    for (int i = 0; i < todayReservations.length; i++) {
      final reservation = todayReservations[i];
      tableData.add([
        (i + 1).toString(),
        reservation['VehicleNumber'],
        reservation['TotalAmount'].toString(),
      ]);
    }

    // Add the total earnings row
    tableData.add(['', 'Total Earnings:', totalEarnings.toString()]);

    return Scaffold(
      appBar: EVAppBar(
        title:
            Text('Report', style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _printDocument(context, station.stationName),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(EVSizes.defaultSpace),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(), // Add border around the container
                ),
                padding: const EdgeInsets.all(EVSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.stationName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Daily Income Report',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: EVSizes.spaceBtwItems),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Date: ',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              now.toLocal().toIso8601String().split('T').first,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Time: ',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              now.toLocal().toIso8601String().split('T').last.substring(0, 8),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: EVSizes.spaceBtwItems),
                Table(
                  border: TableBorder.all(),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FlexColumnWidth(1), // Reservation Number
                    1: FlexColumnWidth(3), // Vehicle Number
                    2: FlexColumnWidth(2), // Total Amount
                  },
                  children: [
                    const TableRow(
                      children: [
                        TableCell(child: Center(child: Text('No'))),
                        TableCell(child: Center(child: Text('Vehicle Number'))),
                        TableCell(child: Center(child: Text('Amount'))),
                      ],
                    ),
                    for (var rowData in tableData)
                      TableRow(
                        children: [
                          TableCell(child: Center(child: Text(rowData[0]))),
                          TableCell(child: Center(child: Text(rowData[1]))),
                          TableCell(child: Center(child: Text(rowData[2]))),
                        ],
                      ),
                  ],
                ),
                        ],
                ),
              ),
        ),
      ],
      ),
    ),
    );
  }

  Future<void> _printDocument(BuildContext context, String stationName) async {
    final pdf = pdfLib.Document();

    pdf.addPage(
      pdfLib.Page(
        build: (pdfLib.Context context) {
          return pdfLib.Column(
            crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
            children: [
              pdfLib.Text(stationName,
                  style: pdfLib.TextStyle(fontSize: 20, fontWeight: pdfLib.FontWeight.bold)),
              pdfLib.SizedBox(height: 2),
              pdfLib.Text('Daily Income Report',
                  style: pdfLib.TextStyle(fontSize: 18, fontWeight: pdfLib.FontWeight.bold)),
              pdfLib.SizedBox(height: 2),
              pdfLib.Text('Date: ${DateTime.now().toString()}',
                  style: const pdfLib.TextStyle(fontSize: 16)),
              pdfLib.SizedBox(height: 20),
              pdfLib.Table.fromTextArray(
                headers: ['No', 'Vehicle Number', 'Total Amount'],
                data: [
                  for (int i = 0; i < todayReservations.length; i++)
                    [
                      (i + 1).toString(),
                      todayReservations[i]['VehicleNumber'],
                      todayReservations[i]['TotalAmount'].toString(),
                    ],
                  ['', 'Total Earnings:', totalEarnings.toString()],
                ],
              ),
              pdfLib.SizedBox(height: 20),
              pdfLib.Text('Total Earnings: $totalEarnings',
                  style: pdfLib.TextStyle(fontSize: 18, fontWeight: pdfLib.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
