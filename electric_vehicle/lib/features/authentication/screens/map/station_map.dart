import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../station/station_detail.dart';

class MarkerManager {

  static BitmapDescriptor? mapMarker;

  static void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), EVImages.marker);
  }

  static Set<Marker> getMarkers(BuildContext context) {
    setCustomMarker();
    return {
      Marker(
        visible: true,
        onTap: () {
          _showInfoWindow(context,
              'ChargeNET(pvt) Ltd',
              'Base 1-5, TRACE Expert City, Tripoli Square, Colombo 01000',
              const LatLng(6.9287548, 79.8618646),
          Container(
            alignment: Alignment.center,
          width: 350, // Set width to 100
          height: 100, // Set height to 100
          decoration: BoxDecoration(
          image: const DecorationImage(
          image: AssetImage(EVImages.stationInfo), // Provide the path to your image asset
          fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10), // Adjust the radius to change the shape (if needed)
          ),
          ),
          );
        },
        markerId: const MarkerId('ChargeNET(pvt) Ltd(station 01)'),
        position: const LatLng(6.9287548, 79.8618646),
        icon: mapMarker!,
      ),
      Marker(
        visible: true,
        onTap: () {
           _showInfoWindow(context,
            'ChargeNET Charging Station',
             'XVQW+GR4, Station Rd, Wattala 11300',
             const LatLng(6.995071837019743, 79.89707120279628),
             Container(
               alignment: Alignment.center,
               width: 350, // Set width to 100
               height: 100, // Set height to 100
               decoration: BoxDecoration(
                 image: const DecorationImage(
                   image: AssetImage(EVImages.stationInfo), // Provide the path to your image asset
                   fit: BoxFit.cover,
                 ),
                 borderRadius: BorderRadius.circular(10), // Adjust the radius to change the shape (if needed)
               ),
             ),
           );
    },
        markerId: const MarkerId('XVQW+GR4, Station Rd, Wattala 11300(station 02)'),
        position: const LatLng(6.995071837019743, 79.89707120279628),
        icon: mapMarker!,
      ),
      Marker(
        visible: true,
        onTap: () {
          _showInfoWindow(context,
            'ChargeNET Charging Station',
            'Devol Bus Stop, Meewitiya Rd, Allalamulla',
            const LatLng(7.168609437535531, 80.13389851926763),
            Container(
              alignment: Alignment.center,
              width: 350, // Set width to 100
              height: 100, // Set height to 100
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(EVImages.stationInfo), // Provide the path to your image asset
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10), // Adjust the radius to change the shape (if needed)
              ),
            ),
          );
        },
        markerId: const MarkerId('Devol Bus Stop, Meewitiya Rd, Allalamulla(station 03)'),
        position: const LatLng(7.168609437535531, 80.13389851926763),
        icon: mapMarker!,
      ),
      Marker(
        visible: true,
        onTap: () {
          _showInfoWindow(context,
            'ChargeNET Charging Station',
            'XW29+H42, Peliyagoda',
            const LatLng(7.168609437535531, 80.13389851926763),
            Container(
              alignment: Alignment.center,
              width: 350, // Set width to 100
              height: 100, // Set height to 100
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(EVImages.stationInfo), // Provide the path to your image asset
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10), // Adjust the radius to change the shape (if needed)
              ),
            ),);
        },
        markerId: const MarkerId('XW29+H42, Peliyagoda(station 04)'),
        position: const LatLng(6.953495689208608, 79.91760783931876),
        icon: mapMarker!,
      ),
      Marker(
        visible: true,
        onTap: () {
          Get.to(const StationDetail());_showInfoWindow(context,
            'ChargeNET Charging Station',
            '7JVM+PG Kandy',
            const LatLng(7.3663326034651755, 80.63832795630243),
            Container(
              alignment: Alignment.center,
              width: 350, // Set width to 100
              height: 100, // Set height to 100
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(EVImages.stationInfo), // Provide the path to your image asset
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10), // Adjust the radius to change the shape (if needed)
              ),
            ),);
        },
        markerId: const MarkerId('7JVM+PG Kandy(station 05)'),
        position: const LatLng(7.3663326034651755, 80.63832795630243),
        icon: mapMarker!,
      ),
    };
  }

  static void _showInfoWindow(BuildContext context,String title, String address, LatLng position, Widget image) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(EVSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  image, // Display the provided image widget
                ],
              ),
              const SizedBox(height: EVSizes.spaceBtwItems/2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () {
                      _openGoogleMapsDirection(position.latitude, position.longitude);
                    },
                    icon: const Icon(
                        Icons.directions,
                        size: 40,
                        color: Color(0xff269E66)),
                  ),
                ],
              ),
              const SizedBox(height: EVSizes.spaceBtwItems/2),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded( // Added Expanded widget
                    child: Text(
                      address,
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),

            ],
          ),
        );
      },
    );
  }

  static Future<void> _openGoogleMapsDirection(double lat, double lng) async {
    final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }
}


