// lib/app_model/clockIn_clockOut_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ClockModel {
  final String clockId;
  final String uId;
  final String userName;
  final String location;
  final DateTime clockInTime;
  final DateTime? clockOutTime;
  final String? locationOut; // Added for clock-out location, as used in controller

  ClockModel({
    required this.clockId,
    required this.uId,
    required this.userName,
    required this.location,
    required this.clockInTime,
    this.clockOutTime,
    this.locationOut,
  });

  // Convert ClockModel object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'clockId': clockId,
      'uId': uId,
      'userName': userName,
      'location': location,
      'clockInTime': Timestamp.fromDate(clockInTime),
      'clockOutTime': clockOutTime != null ? Timestamp.fromDate(clockOutTime!) : null,
      'locationOut': locationOut,
    };
  }

  // Create ClockModel object from a Firestore Map/DocumentSnapshot
  factory ClockModel.fromMap(Map<String, dynamic> data, String id) {
    return ClockModel(
      clockId: id, // Use the document ID as clockId
      uId: data['uId'] as String,
      userName: data['userName'] as String,
      location: data['location'] as String,
      clockInTime: (data['clockInTime'] as Timestamp).toDate(),
      clockOutTime: (data['clockOutTime'] as Timestamp?)?.toDate(),
      locationOut: data['locationOut'] as String?,
    );
  }

  // Helper for creating from DocumentSnapshot
  factory ClockModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ClockModel.fromMap(data, doc.id);
  }
}