import 'dart:async';
import 'package:electric_vehicle/features/authentication/screens/map/station_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(7.8731, 80.7718),
    zoom: 7,
  );

  Set<Marker> _markers = {};

  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _getUserCurrentLocation(); // Fetch user location when the screen is initialized.
  }

  // Method to get user's current location.
  Future<void> _getUserCurrentLocation() async {
    try {
      // Checking permission and fetching current position.
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _updateMarker(position);// Update marker with user's current location.


      // Zooming to the user's location
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          15, // Adjust the zoom level as needed
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  // Method to update marker with user's current location.
  void _updateMarker(Position position) {
    setState(() {
      _markers = {
        ..._markers,
        Marker(
          markerId: const MarkerId("1"),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(
            title: 'My Position',
          ),
        ),
        ...MarkerManager.getMarkers(context),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
      initialCameraPosition: _kGoogle,
      markers: _markers,
      mapType: MapType.normal,
      myLocationEnabled: true,
      compassEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        _mapController = controller;
        },
      ),
    );
  }
}
