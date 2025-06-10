import 'package:cloud_firestore/cloud_firestore.dart';

class ClockModel {
  final String clockId;
  final String uId;
  final String userName;
  final String location;
  final DateTime clockInTime;
  final DateTime? clockOutTime;
  final String? locationOut;
  final DateTime date; // ✅ New field to store only date

  ClockModel({
    required this.clockId,
    required this.uId,
    required this.userName,
    required this.location,
    required this.clockInTime,
    this.clockOutTime,
    this.locationOut,
    required this.date, // ✅ Add to constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'clockId': clockId,
      'uId': uId,
      'userName': userName,
      'location': location,
      'clockInTime': Timestamp.fromDate(clockInTime),
      'clockOutTime': clockOutTime != null ? Timestamp.fromDate(clockOutTime!) : null,
      'locationOut': locationOut,
      'date': Timestamp.fromDate(date), // ✅ Save as date in Firestore
    };
  }

  factory ClockModel.fromMap(Map<String, dynamic> data, String id) {
    return ClockModel(
      clockId: id,
      uId: data['uId'] as String,
      userName: data['userName'] as String,
      location: data['location'] as String,
      clockInTime: (data['clockInTime'] as Timestamp).toDate(),
      clockOutTime: (data['clockOutTime'] as Timestamp?)?.toDate(),
      locationOut: data['locationOut'] as String?,
      date: (data['date'] as Timestamp).toDate(), // ✅ Read from Firestore
    );
  }

  factory ClockModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ClockModel.fromMap(data, doc.id);
  }
}
