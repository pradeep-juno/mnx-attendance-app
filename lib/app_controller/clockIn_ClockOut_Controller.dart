import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_model/clockIn_clockOut_model.dart';
import '../app_router/app_router.dart';



class ClockInClockOutController extends GetxController {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var clockInTime = Rxn<DateTime>();
  var clockOutTime = Rxn<DateTime>();
  var imageFile = Rxn<File>();
  var address = "Fetching location...".obs;
  var userId = ''.obs;
  var userName = ''.obs;
  var clockLogs = <ClockModel>[].obs;
  late Stream<DocumentSnapshot> clockDataStream;
  final loc.Location location = loc.Location();

  loc.LocationData? locationData;

  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();

    getLocationAndAddress();

    loadUserData();

    fetchClockLogs();
  }

  void initLocationAndStatus() {
    getLocationAndAddress();
    fetchClockLogs();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userId.value = prefs.getString('uId') ?? 'unknown_id';

    userName.value = prefs.getString('userName') ?? 'Unknown User';

    print("Loaded userId: ${userId.value}");

    print("Loaded userName: ${userName.value}");
  }

  Future<void> getLocationAndAddress() async {
    final permission = await location.requestPermission();

    if (permission == loc.PermissionStatus.granted) {
      locationData = await location.getLocation();

      if (locationData != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          locationData!.latitude!,

          locationData!.longitude!,
        );

        Placemark place = placemarks[0];

        address.value =
            "${place.street}, ${place.locality}, ${place.administrativeArea}";
      }
    } else {
      address.value = "Permission Denied";
    }
  }

  void clockInNow() {
    clockInTime.value = DateTime.now();
  }

  void clockOutNow() {
    clockOutTime.value = DateTime.now();
  }

  Future<void> pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  void removeImage() {
    imageFile.value = null;
  }

  Future<void> submitClockIn() async {
    if (clockInTime.value == null || address.value == "Fetching location...") {
      Get.snackbar("Error", "Clock-In or Location not available");
      return;
    }

    // Fetch uId dynamically based on userName
    final userSnapshot = await firebaseFirestore
        .collection('user')
        .where('userName', isEqualTo: userName.value)
        .limit(1)
        .get();

    final fetchedUid = userSnapshot.docs.isNotEmpty
        ? userSnapshot.docs.first.id
        : 'unknown_id';

    DocumentReference docRef = firebaseFirestore.collection('clockLogs').doc();

    ClockModel data = ClockModel(
      clockId: docRef.id,
      uId: fetchedUid,
      userName: userName.value,
      location: address.value,
      clockInTime: clockInTime.value!,
      clockOutTime: null,
    );

    await docRef.set(data.toMap());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isClockInDone', true);
    await prefs.setString('uId', fetchedUid);              // Save uId
    await prefs.setString('clockLogId', docRef.id);        // Save clockLogId

    userId.value = fetchedUid; // Keep memory updated

    Get.offNamed(AppRouter.MAIN_NAVIGATION);
  }

  Future<void> submitClockOut() async {
    if (clockOutTime.value == null || address.value == "Fetching location...") {
      Get.snackbar("Error", "Clock-Out time or Location not available");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? docId = prefs.getString('clockLogId');

    if (docId != null) {
      await firebaseFirestore.collection('clockLogs').doc(docId).update({
        'clockOutTime': clockOutTime.value,
      });

      await prefs.setBool('isClockInDone', false);
      await prefs.remove('clockLogId');

      Get.snackbar("Success", "Clock-Out Submitted");
      Get.offNamed(AppRouter.MAIN_NAVIGATION);
    } else {
      Get.snackbar("Error", "No Clock-In session found. Please Clock-In first.");
    }
  }


  Future<void> fetchClockLogs() async {
    final snapshot =
        await firebaseFirestore
            .collection('clockLogs')
            .orderBy('clockInTime', descending: true)
            .limit(1) // Get only the latest one
            .get();
    if (snapshot.docs.isNotEmpty) {
      clockInTime.value =
          ClockModel.fromMap(
            snapshot.docs.first.data(),
            snapshot.docs.first.id,
          ).clockInTime;
    } else {
      clockInTime.value = null; // Or some default value
    }
  }





  void listenClockDataUpdates(BuildContext context, String id) {
    try {
      clockDataStream =
          firebaseFirestore.collection("clockLogs").doc(id).snapshots();

      clockDataStream.listen((documentSnapshots) {
        if (documentSnapshots.exists) {
          clockInTime.value =
              (documentSnapshots['clockInTime'] as Timestamp?)?.toDate();

          clockOutTime.value =
              (documentSnapshots['clockOutTime'] as Timestamp?)?.toDate();

          userId.value = documentSnapshots['uId'] ?? 'Not Found';

          userName.value = documentSnapshots['userName'] ?? 'Not Found';

          print('clockInTime: ${clockInTime.value}');

          print('clockOutTime: ${clockOutTime.value}');

          print('userId: ${userId.value}');

          print('userName: ${userName.value}');
        } else {
          print("ID not found");
        }
      });
    } catch (e) {
      print("Error in listener: $e");
    }
  }


}
