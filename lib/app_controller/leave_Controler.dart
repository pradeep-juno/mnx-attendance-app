import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../app_model/leave_model.dart';
import '../app_router/app_router.dart';
import '../app_utils/app_functions.dart';
import '../storage_services/users_storage_service.dart';
import '../app_utils/app_constants.dart';
import 'auth_controller.dart';
import 'clockIn_ClockOut_Controller.dart';


class LeaveController extends GetxController {
  final firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController reasonController = TextEditingController();

  var annualLeaveCount = '0/12'.obs;
  var sickLeaveCount = '0/14'.obs;
  var compensationalLeaveCount = '0/03'.obs;
  var unpaidLeaveCount = '0/05'.obs;
  var selectedLeaveType = ''.obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var offDayLeaveDuration = 0.obs;
  var reason = ''.obs;
  var totalLeaveDays = 0.obs;
  var leaveCreatedAt = ''.obs;
  var leaveStatus = ''.obs;
  var leaveRequests = <LeaveModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Removed fetchLeaveRequests from onInit.
    // It should be explicitly called after login or when the dashboard loads
    // and a user is confirmed to be logged in.
  }

  /// Resets all leave-related observable data to their initial zero/empty state.
  void resetLeaveData() {
    annualLeaveCount.value = '0/12';
    sickLeaveCount.value = '0/14';
    compensationalLeaveCount.value = '0/03';
    unpaidLeaveCount.value = '0/05';
    leaveRequests.clear(); // Clear the list of fetched requests
    print('Leave data reset to initial state.');
  }
  // Method to set the selected leave type
  void setLeaveType(String value) {
    selectedLeaveType.value = value;
  }

  // Method to set the start date and calculate total leave days
  void setStartDate(DateTime date) {
    startDate.value = date;
    _updateTotalDays();
  }

  // Method to set the end date and calculate total leave days
  void setEndDate(DateTime date) {
    endDate.value = date;
    _updateTotalDays();
  }

  // Method to set the off-day leave duration
  void setOffDayLeaveDuration(int value) {
    offDayLeaveDuration.value = value;
  }

  // Method to set the reason for the leave
  void setReason(String value) {
    reason.value = value;
  }

  // Private method to update the total leave days based on start and end date
  void _updateTotalDays() {
    totalLeaveDays.value =
        endDate.value.difference(startDate.value).inDays + 1;
  }

  // Validation method to check if the leave request form is filled correctly
  bool _validateForm() {
    final isLeaveRequest = totalLeaveDays.value > 0;
    final isPermissionRequest = offDayLeaveDuration.value > 0;

    if (!isLeaveRequest && !isPermissionRequest) {
      Get.snackbar('Validation Error', 'Please specify a leave duration (start and end date) or a permission duration');
      return false;
    }

    if (isLeaveRequest && endDate.value.isBefore(startDate.value)) {
      Get.snackbar('Validation Error', 'End date cannot be before start date');
      return false;
    }

    if (isLeaveRequest && reason.value.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Please enter a reason for leave');
      return false;
    }
    return true;
  }

  // Method to submit the leave request to Firestore
  Future<void> submitLeaveRequest() async {
    if (!_validateForm()) return;

    final uId = UsersStorageService.getUserId() ?? '';
    final userName = UsersStorageService.getUserName() ?? '';

    // Ensure we have a user ID before submitting
    if (uId.isEmpty) {
      Get.snackbar('Error', 'User not authenticated. Please log in.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade100);
      return;
    }

    // Step 1: Create the leave data map (without id)
    final data = {
      'leaveType': selectedLeaveType.value,
      'startDate': Timestamp.fromDate(startDate.value),
      'endDate': Timestamp.fromDate(endDate.value),
      'offDayLeaveDuration': offDayLeaveDuration.value,
      'reason': reason.value.trim(),
      'totalDays': totalLeaveDays.value,
      'authId': uId,
      'userName': userName,
      'leaveCreatedDate': Timestamp.fromDate(DateTime.now()),
      'leaveStatus': 'Pending', // Default status for new requests
    };

    try {
      // Step 2: Add to Firestore
      final docRef = await firebaseFirestore.collection('leaveRequests').add(data);

      // Step 3: Now update the same document with its own ID
      await docRef.update({'id': docRef.id});

      // Step 4: Refresh list
      await fetchLeaveRequests();

      Get.snackbar('Success', 'Leave applied successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black);

      _resetForm();

      Get.toNamed(AppRouter.APPROVAL_QUEUE_SCREEN);
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit leave request: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade100);
      print('Error submitting leave request: $e');
    }
  }
  // Private method to reset the form after submitting a leave request
  void _resetForm() {
    selectedLeaveType.value = '';
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
    offDayLeaveDuration.value = 0;
    reasonController.clear();
    reason.value = ''; // Clear the observable reason as well
    totalLeaveDays.value = 0;
  }
  // Method to count the annual leave days taken
  Future<void> getAnnualLeaveCount() async {
    // Filter the leaveRequests to find annual leave with "approved" status
    final approvedAnnualLeaveRequests = leaveRequests.where((leave) {
      return leave.leaveType == 'Annual Leave' && leave.leaveStatus == 'Approved';
    }).toList();

    // Calculate the total leave days taken for annual leave
    int totalAnnualLeaveDays = approvedAnnualLeaveRequests.fold(0, (sum, leave) {
      return sum + leave.totalDays;
    });

    // Calculate total annual leave available (e.g., 12 days per year)
    int totalAnnualLeaveAvailable = 12; // You can fetch this dynamically if needed

    // Set the count in the observable variable
    annualLeaveCount.value = '$totalAnnualLeaveDays/$totalAnnualLeaveAvailable';
  }

  Future<void> getSickLeaveCount() async {
    // Filter the leaveRequests to find annual leave with "approved" status
    final approvedSickLeaveRequests = leaveRequests.where((leave) {
      return leave.leaveType == 'Sick Leave' && leave.leaveStatus == 'Approved';
    }).toList();

    // Calculate the total leave days taken for annual leave
    int totalSickLeaveDays = approvedSickLeaveRequests.fold(0, (sum, leave) {
      return sum + leave.totalDays;
    });

    // Calculate total annual leave available (e.g., 12 days per year)
    int totalSickLeaveAvailable = 14; // You can fetch this dynamically if needed

    // Set the count in the observable variable
    sickLeaveCount.value = '$totalSickLeaveDays/$totalSickLeaveAvailable';
  }

  Future<void> getCompensationalLeaveCount() async {
    // Filter the leaveRequests to find annual leave with "approved" status
    final approvedCompensationalLeaveRequests = leaveRequests.where((leave) {
      return leave.leaveType == 'Compensational Leave' && leave.leaveStatus == 'Approved';
    }).toList();

    // Calculate the total leave days taken for annual leave
    int totalCompensationalLeaveDays = approvedCompensationalLeaveRequests.fold(0, (sum, leave) {
      return sum + leave.totalDays;
    });

    // Calculate total annual leave available (e.g., 12 days per year)
    int totalCompensationalLeaveAvailable = 3;
    // Set the count in the observable variable
    compensationalLeaveCount.value = '$totalCompensationalLeaveDays/$totalCompensationalLeaveAvailable';
  }

  Future<void> getUnpaidLeaveCount() async {
    // Filter the leaveRequests to find annual leave with "approved" status
    final approvedUnpaidLeaveRequests = leaveRequests.where((leave) {
      return leave.leaveType == 'Unpaid Leave' && leave.leaveStatus == 'Approved';
    }).toList();

    // Calculate the total leave days taken for annual leave
    int totalUnpaidLeaveDays = approvedUnpaidLeaveRequests.fold(0, (sum, leave) {
      return sum + leave.totalDays;
    });

    // Calculate total annual leave available (e.g., 12 days per year)
    int totalUnpaidLeaveAvailable = 5;

    // Set the count in the observable variable
    unpaidLeaveCount.value = '$totalUnpaidLeaveDays/$totalUnpaidLeaveAvailable';
  }

  // Method to fetch leave requests from Firestore
  Future<void> fetchLeaveRequests() async {
    try {
      final authId = UsersStorageService.getUserId() ?? '';

      // If no user ID is found, reset data and return
      if (authId.isEmpty) {
        print('No authenticated user ID found. Resetting leave data.');
        resetLeaveData(); // If no user, reset and stop fetching
        return;
      }

      print('Fetching leave requests for user: $authId');
      final querySnapshot = await firebaseFirestore
          .collection('leaveRequests')
          .where('authId', isEqualTo: authId)
          .orderBy('leaveCreatedDate', descending: true)
          .get();

      final leaveData = querySnapshot.docs.map((doc) {
        return LeaveModel.fromMap(doc.data(), doc.id);
      }).toList();

      leaveRequests.value = leaveData;

      // Now update the leave counts based on filtered data
      getAnnualLeaveCount();
      getSickLeaveCount();
      getCompensationalLeaveCount();
      getUnpaidLeaveCount();
      print('Leave data fetched successfully for user: $authId');

    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch leave requests: $e',
          snackPosition: SnackPosition.BOTTOM);
      print('Error fetching leave requests: $e');
    }
  }


  Future<void> updateLeaveStatus(String docId, String newStatus) async {
    try {
      await firebaseFirestore
          .collection('leaveRequests')
          .doc(docId)
          .update({'leaveStatus': newStatus});

      // Refresh the list
      await fetchLeaveRequests();

      Get.snackbar('Success', 'Leave status updated to $newStatus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}

// Your existing logout function, modified to reset LeaveController data
Future<void> logout(BuildContext context, AuthController authController) async {
  try {
    authController.isLoading.value = true;

    await FirebaseAuth.instance.signOut();
    print(AppConstants.logoutSuccessFully);

    //  Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('SharedPreferences cleared.');

    // Reset LeaveController if available
    if (Get.isRegistered<LeaveController>()) {
      Get.find<LeaveController>().resetLeaveData();
      print('LeaveController data reset after logout.');
    }

    //  Reset ClockInClockOutController if available
    if (Get.isRegistered<ClockInClockOutController>()) {
      final clockController = Get.find<ClockInClockOutController>();

      // Clear local session state
      clockController.isClockedIn.value = false;
      clockController.currentClockLogDocId.value = null;
      clockController.clockInTime.value = null;
      clockController.clockOutTime.value = null;

      // Clear local storage (but not Firestore data)
      await UsersStorageService.saveClockInStatus(false);
      await UsersStorageService.saveCurrentClockLogId(null);

      // Cancel any scheduled reminders
      clockController.cancelReminders();

      print('ClockInClockOutController session cleared after logout.');
    }

    buildScaffoldSuccessMessage(context, AppConstants.logoutSuccessFully);

    // Navigate back to login screen
    Get.offAllNamed(AppRouter.LOGIN_SCREEN);
  } catch (e) {
    print('Error during logout: $e');
    Get.snackbar(
      'Error',
      'Failed to logout: $e',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
    );
  } finally {
    authController.isLoading.value = false;
  }
}
