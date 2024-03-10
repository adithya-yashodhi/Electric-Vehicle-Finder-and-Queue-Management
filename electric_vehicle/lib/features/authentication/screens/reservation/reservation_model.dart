import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationModel {
  final String id;
  final DateTime selectedDate;
  final String selectedSlot;
  //final String selectedStationId;
 // final String userId;

  ReservationModel({
    required this.selectedDate,
    required this.selectedSlot,
    //required this.selectedStationId,
   // required this.userId,
    required this.id,
  });

  static ReservationModel empty() =>
      ReservationModel(
          selectedDate: DateTime.now(),
          selectedSlot: '',
          //selectedStationId: '',
        //  userId: '',
          id: ''
      );

  Map<String, dynamic> toJson() {
    return {
     // 'StationId': selectedStationId,
      //'UserId': userId,
      'SelectedDate': selectedDate,
      'SelectedTimeSlot': selectedSlot,
    };
  }

  factory ReservationModel.fromMap(Map<String, dynamic> data) {
    return ReservationModel(
      id: data['Id'] as String,
     // selectedStationId: data['StationId'] as String,
     // userId: data['UserId'] as String,
      selectedSlot: data['SelectedTimeSlot'] as String,
      selectedDate: data['SelectedDate'] as DateTime,
    );
  }

  factory ReservationModel.fromDocumentSnapShot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ReservationModel(
      id: snapshot.id,
    //  selectedStationId: data['StationId'] ?? '',
     // userId: data['UserId'] ?? '',
      selectedSlot: data['SelectedTimeSlot'] ?? '',
      selectedDate: data['SelectedDate'].toDate(),
    );
  }

}
