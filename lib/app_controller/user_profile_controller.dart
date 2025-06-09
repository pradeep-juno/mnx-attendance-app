import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../app_utils/app_constants.dart';
import '../storage_services/users_storage_service.dart';

class UserProfileController extends GetxController {
  var authId = ''.obs;
  var authName = ''.obs;
  var authMobileNumber = ''.obs;
  var authEmailAddress = ''.obs;
  var authPassword = ''.obs;
  var authConfirmPassword = ''.obs;
  var authPosition = ''.obs;

  late Stream<DocumentSnapshot> userDataStream;

  void listenToUserProfileDataUpdates() {
    try {
      print("ListenToUserProfileDataUpdates....");

      final userId = UsersStorageService.getUserId();

      userDataStream = FirebaseFirestore.instance
          .collection(AppConstants.collectionAuth)
          .doc(userId)
          .snapshots();

      userDataStream.listen((documentSnapshot) {
        if (documentSnapshot.exists) {
          // Update reactive variables with fetched data
          authId.value = documentSnapshot['authId'] ?? 'Unknown';
          authName.value = documentSnapshot['authName'] ?? 'Unknown';

          print("AuthName : ${authName.value}");

          authMobileNumber.value =
              documentSnapshot['authMobileNumber'] ?? 'Unknown';
          authEmailAddress.value =
              documentSnapshot['authEmailAddress'] ?? 'Unknown';
          authPassword.value = documentSnapshot['authPassword'] ?? 'Unknown';
          authConfirmPassword.value =
              documentSnapshot['authConfirmPassword'] ?? 'Unknown';
          authPosition.value = documentSnapshot['position'] ?? 'Unknown';

          print("User Profile Fetched Successfully");
        } else {
          print("No User data found for this ID");
        }
      });
    } catch (e) {
      print('Error listening to User data updates: $e');
    }
  }


  Future<void> updateUserProfile({
    required String name,
    required String mobileNumber,
  }) async {
    try {
      final userId = UsersStorageService.getUserId();

      await FirebaseFirestore.instance
          .collection(AppConstants.collectionAuth)
          .doc(userId)
          .update({
        'authName': name,
        'authMobileNumber': mobileNumber,
      });

      // Update local observable values
      authName.value = name;
      authMobileNumber.value = mobileNumber;

      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    }
  }


}
