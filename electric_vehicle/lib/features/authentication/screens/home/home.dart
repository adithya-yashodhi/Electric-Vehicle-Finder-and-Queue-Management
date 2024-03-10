import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electric_vehicle/features/authentication/screens/home/widgets/home_appbar.dart';
import 'package:electric_vehicle/features/authentication/screens/station/widgets/station_meta_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/widgets/custom_shapes/container/primary_header_container.dart';
import '../../../../common/widgets/custom_shapes/container/rounded_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference<Map<String, dynamic>> adminCollection =
  FirebaseFirestore.instance.collection('Admin');

  late List<Map<String, dynamic>> items = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    List<Map<String, dynamic>> tempList = [];

    var adminData = await adminCollection.get();

    for (var adminDoc in adminData.docs) {
      var stationsData = await adminDoc.reference.collection('Stations').get();

      for (var stationDoc in stationsData.docs) {
        var stationData = stationDoc.data();
        var portsData = await stationDoc.reference.collection('Ports').get();

        var portList =
        portsData.docs.map((portDoc) => portDoc.data()).toList();
        stationData['ports'] = portList;

        tempList.add(stationData);
      }
    }

    setState(() {
      items = tempList;
      isLoaded = true;
    });
  }

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const EVPrimaryHeaderContainer(
              child: Column(
                children: [
                  EVHomeAppBar(),
                  SizedBox(height: EVSizes.spaceBtwSections),
                ],
              ),
            ),
            isLoaded
                ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                var station = items[index];
                var ports = station['ports'] as List<Map<String, dynamic>>;

                return GestureDetector(
                  onTap: () {
                    // Navigate to EVStationMetaData screen and pass relevant data
                    if (kDebugMode) {
                      print("Tapped item data: $station");
                      print("Tapped item data: $ports");
                    }
                    Navigator.push( context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EVStationMetaData(stationData: station, portsData: ports),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:EVSizes.defaultSpace,
                        left: EVSizes.defaultSpace, right: EVSizes.defaultSpace),
                    child: EVRoundedContainer(
                      showBorder: true,
                      padding: const EdgeInsets.all(EVSizes.defaultSpace),
                      backgroundColor: dark ? EVColors.dark : EVColors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            station["StationName"] ??
                                                "Not given",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall),
                                        const Spacer(),
                                        IconButton(onPressed: () {
                                            final latitude = station["Latitude"];
                                            final longitude = station["Longitude"];

                                            if (latitude != null && longitude != null) {
                                              _launchMaps(double.parse(latitude.toString()),
                                                  double.parse(longitude.toString()));
                                            } else {
                                              if (kDebugMode) {
                                                print("Latitude or longitude is null");
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
                                    const SizedBox(height: EVSizes.spaceBtwItems/2),
                                    Text(
                                      station["StationAddress"] ??
                                          "Not given",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .apply(
                                          color:
                                          EVColors.textSecondary),
                                      overflow: TextOverflow.ellipsis,
                                      // Optional: handle overflow with ellipsis
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: EVSizes.spaceBtwItems/2),
                                    Text(
                                      station["PhoneNumber"]
                                          ?.toString() ??
                                          "Not given",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .apply(
                                          color:
                                          EVColors.textSecondary),
                                    ),
                                    const SizedBox(height: EVSizes.spaceBtwItems),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: ports.length,
                                      itemBuilder: (context, portIndex) {
                                        var port = ports[portIndex];
                                        return Row(
                                          children: [
                                            const Icon(Icons.electric_bolt, color: Colors.grey),
                                            const SizedBox(width: 8),
                                            Text(port["PortType"] ??
                                                "Not given", style: Theme.of(context).textTheme.bodyLarge!.apply(color: EVColors.textSecondary),),
                                            const SizedBox(width: 8),
                                            Text('.',style: Theme.of(context).textTheme.bodyLarge!.apply(color: EVColors.textSecondary)),
                                            const SizedBox(width: 8),
                                            Text(port["Capacity"] ??
                                                "Not given", style: Theme.of(context).textTheme.bodyLarge!.apply(color: EVColors.textSecondary),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ),
                );
              },
            )
                : const Center(child: CircularProgressIndicator()),
            const SizedBox(height: EVSizes.spaceBtwItems),
          ],
        ),
      ),
    );
  }
}
