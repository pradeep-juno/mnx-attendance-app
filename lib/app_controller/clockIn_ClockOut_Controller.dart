import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mnx_attendance_app/app_utils/app_colors.dart';

import '../app_model/clockIn_clockOut_model.dart';
import '../app_router/app_router.dart';
import '../app_utils/app_functions.dart';
import '../storage_services/users_storage_service.dart';

class ClockInClockOutController extends GetxController {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  var clockInTime = Rxn<DateTime>();
  var clockOutTime = Rxn<DateTime>();
  var address = "Fetching location...".obs;
  var currentUserId = ''.obs;
  var currentUserName = ''.obs;
  var isClockedIn = false.obs;
  var currentClockLogDocId = Rxn<String>();
  var missedAttendanceCount = 0.obs;

  final loc.Location location = loc.Location();
  loc.LocationData? locationData;

  Timer? _clockInReminderTimer;
  Timer? _clockOutReminderTimer;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    getLocationAndAddress();
    scheduleClockInReminder();
    scheduleClockOutReminder();
  }


  Future<void> _loadInitialData() async {
    currentUserId.value = UsersStorageService.getUserId() ?? 'unknown_id';
    currentUserName.value = UsersStorageService.getUserName() ?? 'Unknown User';

    // Always attempt to fetch today's clock logs from Firestore
    // to determine the actual clock-in status for the current day.
    final todayLog = await _getTodayClockLog(); // Use the existing helper
    if (todayLog != null) {
      isClockedIn.value = todayLog['clockOutTime'] == null; // If clockOutTime is null, they are still clocked in
      currentClockLogDocId.value = todayLog['clockId']; // Assuming clockId is part of the returned map
      clockInTime.value = (todayLog['clockInTime'] as Timestamp?)?.toDate();
      clockOutTime.value = (todayLog['clockOutTime'] as Timestamp?)?.toDate();
    } else {
      // No log for today, so user is not clocked in
      isClockedIn.value = false;
      currentClockLogDocId.value = null;
      clockInTime.value = null;
      clockOutTime.value = null;
    }

    // Update local storage based on the actual Firestore status
    await UsersStorageService.saveClockInStatus(isClockedIn.value);
    await UsersStorageService.saveCurrentClockLogId(currentClockLogDocId.value);

    // Schedule reminders based on the determined status
    if (!isClockedIn.value) {
      scheduleClockInReminder();
    } else if (isClockedIn.value && clockOutTime.value == null) {
      scheduleClockOutReminder(); // Only schedule if clocked in and not clocked out
    }
  }

  Future<List<ClockModel>> getMissedAttendanceRecords(DateTime start, DateTime end) async {
    final records = await getAttendanceRecordsForUser(
      userId: currentUserId.value,
      startDate: start,
      endDate: end,
    );

    final missedRecords = records.where((record) =>
    record.clockInTime == null || record.clockOutTime == null
    ).toList();

    // ✅ Update the dynamic observable
    missedAttendanceCount.value = missedRecords.length;

    return missedRecords;
  }


  Future<void> fetchTodayClockLogs() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    try {
      final querySnapshot = await firebaseFirestore
          .collection('clockLogs')
          .where('uId', isEqualTo: currentUserId.value)
          .where('clockInTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('clockInTime', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      final todayLogs = querySnapshot.docs.map((doc) {
        return {
          'userName': doc['userName'],
          'clockInTime': (doc['clockInTime'] as Timestamp).toDate(),
          'clockOutTime': (doc['clockOutTime'] as Timestamp?)?.toDate(),
          'location': doc['location'],
        };
      }).toList();

      print(todayLogs);
    } catch (e) {
      print("Error fetching today’s clock logs: $e");
    }
  }

  Future<void> getLocationAndAddress() async {
    try {
      final permission = await location.requestPermission();
      if (permission == loc.PermissionStatus.granted) {
        locationData = await location.getLocation();
        if (locationData != null && locationData!.latitude != null && locationData!.longitude != null) {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            locationData!.latitude!,
            locationData!.longitude!,
          );
          Placemark place = placemarks[0];
          address.value = "${place.street}, ${place.locality}, ${place.administrativeArea}";
        } else {
          address.value = "Location data not available.";
        }
      } else {
        address.value = "Location Permission Denied";
        Get.snackbar("Permission Denied", "Please grant location permission to use this feature.");
      }
    } catch (e) {
      address.value = "Error fetching location.";
      print("Error in getLocationAndAddress: $e");
      Get.snackbar("Error", "Failed to get location: $e");
    }
  }

  void clockInNow() {
    clockInTime.value = DateTime.now();
  }

  void clockOutNow() {
    clockOutTime.value = DateTime.now();
  }

  Future<void> submitClockIn() async {
    if (currentUserId.value == 'unknown_id' || currentUserName.value == 'Unknown User') {
      Get.snackbar("Error", "User data not loaded. Please log in again.");
      return;
    }

    if (clockInTime.value == null || address.value.contains("Fetching location") || address.value.contains("Permission Denied") || address.value.contains("Error fetching location")) {
      Get.snackbar("Error", "Clock-In time or valid Location not available.");
      return;
    }

    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

    try {
      DocumentReference docRef = firebaseFirestore.collection('clockLogs').doc();
      ClockModel data = ClockModel(
        clockId: docRef.id,
        uId: currentUserId.value,
        userName: currentUserName.value,
        location: address.value,
        clockInTime: clockInTime.value!,
        clockOutTime: null,
      );

      await docRef.set(data.toMap());

      await UsersStorageService.saveClockInStatus(true);
      await UsersStorageService.saveCurrentClockLogId(docRef.id);

      isClockedIn.value = true;
      currentClockLogDocId.value = docRef.id;

      Get.back();
      Get.snackbar("Success", "Clock-In Recorded Successfully!");
      Get.offNamed(AppRouter.MAIN_NAVIGATION);
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Failed to submit Clock-In: $e");
      print("Error submitting clock-in: $e");
    }
  }

  Future<void> submitClockOut() async {
    if (clockOutTime.value == null || address.value.contains("Fetching location") || address.value.contains("Permission Denied") || address.value.contains("Error fetching location")) {
      Get.snackbar("Error", "Clock-Out time or valid Location not available.");
      return;
    }

    if (!isClockedIn.value || currentClockLogDocId.value == null) {
      Get.snackbar("Error", "No active Clock-In session found. Please Clock-In first.");
      return;
    }

    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

    try {
      await firebaseFirestore.collection('clockLogs').doc(currentClockLogDocId.value).update({
        'clockOutTime': Timestamp.fromDate(clockOutTime.value!),
        'locationOut': address.value,
      });

      await UsersStorageService.saveClockInStatus(false);
      await UsersStorageService.saveCurrentClockLogId(null);

      Get.back();
      Get.snackbar("Success", "Clock-Out Recorded Successfully!");
      Get.offNamed(AppRouter.MAIN_NAVIGATION);
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Failed to submit Clock-Out: $e");
      print("Error submitting clock-out: $e");
    }
  }

  Future<List<ClockModel>> getAttendanceRecordsForUser({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      DateTime startOfDay = DateTime(startDate.year, startDate.month, startDate.day);
      DateTime endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

      final QuerySnapshot result = await firebaseFirestore
          .collection('clockLogs')
          .where('uId', isEqualTo: userId)
          .where('clockInTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('clockInTime', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('clockInTime', descending: false)
          .get();

      return result.docs
          .map((doc) => ClockModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting user attendance records: $e');
      rethrow;
    }
  }

  String getAttendanceStatus(ClockModel record) {
    final DateTime standardStartTime = DateTime(record.clockInTime.year, record.clockInTime.month, record.clockInTime.day, 15, 59, 0);
    final DateTime standardEndTime = DateTime(record.clockInTime.year, record.clockInTime.month, record.clockInTime.day, 16, 0, 0);

    if (record.clockInTime.isAfter(standardStartTime.add(const Duration(minutes: 15)))) {
      return "Late Arrival";
    }

    if (record.clockOutTime != null && record.clockOutTime!.isBefore(standardEndTime.subtract(const Duration(minutes: 15)))) {
      return "Early Departure";
    }

    if (record.clockOutTime != null && record.clockOutTime!.isAfter(standardEndTime.add(const Duration(minutes: 30)))) {
      return "Over Time";
    }

    if (record.clockOutTime != null) {
      return "Present";
    }

    return "Absent";
  }

  /// --- REMINDER LOGIC ---
  void scheduleClockInReminder() async {
    final hasClockedIn = await _hasClockedInToday();

    if (!hasClockedIn) {
      _clockInReminderTimer = Timer(const Duration(minutes: 1), () async {
        final stillNotClockedIn = !(await _hasClockedInToday());
        if (stillNotClockedIn) {
          _showReminderDialog("Clock-In Reminder", "You haven't clocked in yet. Please do so.");
        }
      });
    }
  }

  void scheduleClockOutReminder() async {
    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, 17, 0);

    if (now.isBefore(scheduledTime)) {
      final durationUntilReminder = scheduledTime.difference(now);

      _clockOutReminderTimer = Timer(durationUntilReminder, () async {
        final hasClockedOut = await _hasClockedOutToday();
        if (!hasClockedOut) {
          _showReminderDialog("Clock-Out Reminder", "You haven't clocked out yet. Please remember to do so.");
        }
      });
    }
  }

  void cancelReminders() {
    _clockInReminderTimer?.cancel();
    _clockOutReminderTimer?.cancel();
  }

  Future<bool> _hasClockedInToday() async {
    final record = await _getTodayClockLog();
    return record != null && record['clockInTime'] != null;
  }

  Future<bool> _hasClockedOutToday() async {
    final record = await _getTodayClockLog();
    return record != null && record['clockOutTime'] != null;
  }

  Future<Map<String, dynamic>?> _getTodayClockLog() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = await firebaseFirestore
        .collection('clockLogs')
        .where('uId', isEqualTo: currentUserId.value)
        .where('clockInTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('clockInTime', isLessThan: Timestamp.fromDate(endOfDay))
        .limit(1)
        .get();

    if (result.docs.isNotEmpty) {
      final docData = result.docs.first.data();
      // Ensure 'clockId' is always in the stored document. If not, add it in your Firestore writes.
      // For now, let's assume it's there or we'll get it from result.docs.first.id
      docData['clockId'] = result.docs.first.id; // Add the document ID to the map
      return docData;
    } else {
      return null;
    }
  }

  void clearSessionData() {
    isClockedIn.value = false;
    currentClockLogDocId.value = null;
    clockInTime.value = null;
    clockOutTime.value = null;
    UsersStorageService.saveClockInStatus(false);
    UsersStorageService.saveCurrentClockLogId(null);
    cancelReminders();
  }


  void _showReminderDialog(String title, String message) {
    if (Get.isDialogOpen != true) {
      Get.dialog(
        buildClockInAndOutReminder(title, message),
        barrierDismissible: false,
      );
    }
  }


}
