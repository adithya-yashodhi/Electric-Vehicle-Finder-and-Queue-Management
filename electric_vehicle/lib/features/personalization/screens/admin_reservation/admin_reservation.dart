import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../authentication/screens/admin_station/controller/station_controller.dart';
import 'admin_reservation_list.dart';

class AdminReservationScreen extends StatelessWidget {
  const AdminReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(StationController());
    final station = controller.station.value;
    return Scaffold(
      appBar: EVAppBar(
        title: Text('Reservation', style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(EVSizes.defaultSpace),

        /// --bookings
        child: AdminReservationListItems(stationId: station.id,),
      ),
    );
  }
}
