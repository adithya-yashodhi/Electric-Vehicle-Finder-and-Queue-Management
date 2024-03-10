import 'package:electric_vehicle/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../reservation/book_slot.dart';

class EVStationMetaData extends StatelessWidget {
  final Map<String, dynamic>? stationData;
  final List<Map<String, dynamic>>? portsData;

  const EVStationMetaData({Key? key, this.stationData, this.portsData}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (stationData == null || portsData == null) {
      // Handle null data case
      return const Scaffold(
        appBar: EVAppBar(showBackArrow: true),
        body: Center(
          child: Text("Station data or ports data is null"),
        ),
      );
    }

    //final stationId = stationData!['Id'];

    return Scaffold(
        appBar: const EVAppBar(showBackArrow: true),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(EVSizes.defaultSpace),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        SizedBox(
                          width: double.infinity, // Set the width of the container
                          height: 200, // Set the height of the container
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10), // Clip the image with rounded corners
                            child: Image.network(
                              stationData!['ProfilePicture'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey, // Placeholder image color
                                  child: const Center(child: Text('Image not found')), // Placeholder text
                                );
                              },
                            ),
                          ),
                        ),

                    const SizedBox(height: EVSizes.spaceBtwSections),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stationData!["StationName"] ?? '',style: Theme.of(context)
                            .textTheme.headlineMedium),
                        const SizedBox(height: EVSizes.spaceBtwItems),
                        Text(stationData!["Description"] ?? '',style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .apply(color: Colors.grey)),
                        const SizedBox(height: EVSizes.spaceBtwItems),
                        Text('Open',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .apply(color: Colors.green[900])),
                        const SizedBox(height: EVSizes.spaceBtwItems),
                        const Divider(),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Color(0xff269E66)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                  stationData!["StationAddress"] ?? '',
                                style: Theme.of(context).textTheme.bodyLarge,
                                overflow: TextOverflow.ellipsis,
                                // Optional: handle overflow with ellipsis
                                maxLines:
                                    2, // Optional: limit the number of lines
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Icon(Icons.watch_later,
                                color: Color(0xff269E66)),
                            const SizedBox(width: 8),
                            Text(
                              'Open 24 hours',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Icon(Icons.call, color: Color(0xff269E66)),
                            const SizedBox(width: 8),
                            Text(stationData!["PhoneNumber"] ?? '',
                                style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: EVSizes.spaceBtwItems),
                        Row(
                          children: [
                            Text('Available Connectors',
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                        const SizedBox(height: EVSizes.spaceBtwSections),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: portsData!.length,
                          itemBuilder: (context, portIndex) {
                            var port = portsData![portIndex];
                            return Column(
                              children: [
                                Row(
                                children: [
                                const Icon(Icons.electric_bolt, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(port["PortType"] ?? "Not given", style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.black87)),
                                const SizedBox(width: 8),
                                Text('.', style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.black87)),
                                const SizedBox(width: 8),
                                Text(port["Capacity"] ?? "Not given", style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.black87)),
                                ]
                                ),
                                const SizedBox(height: EVSizes.spaceBtwItems/2),
                                Row(
                                  children: [
                                    Text('Price for Charging:', style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.black87)),
                                    const SizedBox(width: 8),
                                    Text(port["Price"] ?? "Not given", style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.black87)),
                                    const Spacer(),
                                    Column(
                                      children: [
                                      Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('Total:', style: Theme.of(context).textTheme.bodyLarge!.apply(color: EVColors.textSecondary)),
                                        const SizedBox(width: 8),
                                        Text(port["NoOfPorts"] ?? "Not given", style: Theme.of(context).textTheme.bodyLarge!.apply(color: EVColors.textSecondary)),
                                      ],
                                      )
                                      ]
                                    )
                                  ],
                                ),
                                const SizedBox(height: EVSizes.spaceBtwSections),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: EVSizes.spaceBtwSections),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Get.to(() => AddReservationPage(
                                ports: portsData!.map((port) => port['PortType'].toString()).toList(),
                                stationData: stationData!,
                                portsData: portsData!,
                            ),
                            ),
                            child: const Text(EVTexts.book),
                          ),
                        ),
                      ],
                    )
                  ]
    )
            )
                )
  );
  }
}
