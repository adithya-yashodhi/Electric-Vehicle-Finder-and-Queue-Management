import 'package:electric_vehicle/features/personalization/screens/vehicle/controller/vehicle_controller.dart';
import 'package:electric_vehicle/network_manager.dart';
import 'package:get/get.dart';

import '../features/personalization/screens/payment/checkout_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(VehicleController());
    Get.put(CheckoutController());
  }
}