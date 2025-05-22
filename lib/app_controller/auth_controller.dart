import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_model/auth_model.dart';
import '../app_router/app_router.dart';
import '../app_utils/app_constants.dart';
import '../app_utils/app_functions.dart';
import '../storage_services/users_storage_service.dart';

class AuthController extends GetxController {
  final authKey = GlobalKey<FormState>();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final authNameController = TextEditingController();
  final authMobileNumberController = TextEditingController();
  final authEmailAddressController = TextEditingController();
  final authPasswordController = TextEditingController();
  final authConfirmPasswordController = TextEditingController();
  final authPositionController = TextEditingController();

  final authOldPasswordController = TextEditingController();
  final authNewPasswordController = TextEditingController();
  final authConfirmNewPasswordController = TextEditingController();

  final authLoginEmailAddressController = TextEditingController();
  final authLoginPasswordController = TextEditingController();

  var isLoading = false.obs;

  Future<void> register(BuildContext context) async {
    if (await registerValidateFields(context)) {
      try {
        isLoading.value = true;

        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: authEmailAddressController.text.trim(),
          password: authPasswordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          var docRef = FirebaseFirestore.instance
              .collection(AppConstants.collectionAuth)
              .doc(user.uid);

          var authData = AuthModel(
            authId: user.uid,
            authName: authNameController.text.trim(),
            authMobileNumber: authMobileNumberController.text.trim(),
            authEmailAddress: user.email!,
            authPassword: authPasswordController.text.trim(),
            authConfirmPassword: authConfirmPasswordController.text.trim(),
            position: authPositionController.text.trim() ,
          );

          await docRef.set(authData.toMap());

          print("auth Reg User : ${authData.toString()}");

          UsersStorageService.saveUser(
            user.uid,
            authData.authName,
            authData.authMobileNumber,
            authData.authEmailAddress,
            authData.authPassword,
            authData.position,
          );

          isLoading.value = false;
          buildScaffoldSuccessMessage(context, "Registered successfully");
          clearController();
          Get.offNamed(AppRouter.ONBOARD_VIEW);
        } else {
          isLoading.value = false;
          buildScaffoldErrorMessage(context, "User creation failed.");
        }
      } catch (e) {
        isLoading.value = false;
        buildScaffoldErrorMessage(context, 'Failed to register: $e');
      }
    }
  }

  registerValidateFields(BuildContext context) async {
    String authName = authNameController.text.trim();
    String authMobileNumber = authMobileNumberController.text.trim();
    String authEmailAddress = authEmailAddressController.text.trim();
    String authPassword = authPasswordController.text.trim();
    String authConfirmPassword = authConfirmPasswordController.text.trim();
    String authPosition = authPositionController.text.trim();

    if (authName.isEmpty) {
      buildScaffoldErrorMessage(context, 'Please enter Name');
      return false;
    }
    if (authMobileNumber.isEmpty) {
      buildScaffoldErrorMessage(context, 'Please enter Mobile Number');
      return false;
    } else if (authMobileNumber.length < 10) {
      buildScaffoldErrorMessage(context, 'Invalid mobile number');
      return false;
    } else if (await isFieldExist('authMobileNumber', authMobileNumber)) {
      buildScaffoldErrorMessage(context, 'Mobile number already registered');
      return false;
    }

    if (authEmailAddress.isEmpty) {
      buildScaffoldErrorMessage(context, 'Please enter Email Address');
      return false;
    } else if (!EmailValidator.validate(authEmailAddress) ||
        !authEmailAddress.endsWith('@gmail.com')) {
      buildScaffoldErrorMessage(context, 'Please enter a valid Gmail address');
      return false;
    } else if (await isFieldExist('authEmailAddress', authEmailAddress)) {
      buildScaffoldErrorMessage(context, 'Email already registered');
      return false;
    }

    if (authPassword.isEmpty || authPassword.length < 4) {
      buildScaffoldErrorMessage(context, 'Password must be at least 4 letters');
      return false;
    }

    if (authConfirmPassword.isEmpty ||
        authConfirmPassword.length < 4 ||
        authPassword != authConfirmPassword) {
      buildScaffoldErrorMessage(
          context, 'Password and Confirm Password do not match');
      return false;
    }

    if (authPosition.isEmpty) {
      buildScaffoldErrorMessage(context, 'Please enter Position');
      return false;
    }

    return true;
  }

  void clearController() {
    authNameController.clear();
    authMobileNumberController.clear();
    authEmailAddressController.clear();
    authPasswordController.clear();
    authConfirmPasswordController.clear();
    authPositionController.clear();
  }

  Future<bool> isFieldExist(String fieldName, String fieldValue) async {
    var querySnapshot = await firebaseFirestore
        .collection(AppConstants.collectionAuth)
        .where(fieldName, isEqualTo: fieldValue)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> login(BuildContext context) async {
    if (await loginValidateFields(context)) {
      isLoading.value = true;

      String authEmailAddress = authEmailAddressController.text.trim();
      String authPassword = authPasswordController.text.trim();

      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: authEmailAddress,
          password: authPassword,
        );

        User? user = userCredential.user;
        if (user != null) {
          DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance
              .collection(AppConstants.collectionAuth)
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            Map<String, dynamic>? userData = userDoc.data();

            if (userData != null) {
              String authName = userData['authName'] ?? 'User';
              String authMobileNumber = userData['authMobileNumber'] ?? '';
              String authEmailAddress = userData['authEmailAddress'] ?? '';
              String authPassword = userData['authPassword'] ?? '';
              String authPosition = userData['position'] ?? '';

              UsersStorageService.saveUser(
                user.uid,
                authName,
                authMobileNumber,
                authEmailAddress,
                authPassword,
                  authPosition
              );

              isLoading.value = false;
              buildScaffoldSuccessMessage(
                  context, 'Login Successful, Welcome $authName!');

clearController();
              // Always go to AgentMainScreen
              Get.offNamed(AppRouter.AGENT_MAIN_SCREEN);
            } else {
              isLoading.value = false;
              buildScaffoldErrorMessage(
                  context, 'Incomplete user data. Please contact support.');
            }
          } else {
            isLoading.value = false;
            buildScaffoldErrorMessage(
                context, 'No user data found. Please register.');
          }
        } else {
          isLoading.value = false;
          buildScaffoldErrorMessage(
              context, 'Authentication failed. Try again.');
        }
      } catch (e) {
        isLoading.value = false;
        String errorMessage = getErrorMessage(e);
        buildScaffoldErrorMessage(context, errorMessage);
      }
    }
  }

  loginValidateFields(BuildContext context) async {
    String authEmailAddress = authEmailAddressController.text.trim();
    String authPassword = authPasswordController.text.trim();

    if (authEmailAddress.isEmpty) {
      buildScaffoldErrorMessage(context, 'Please enter Email Address');
      return false;
    } else if (!EmailValidator.validate(authEmailAddress) ||
        !authEmailAddress.endsWith('@gmail.com')) {
      buildScaffoldErrorMessage(context, 'Please enter a valid Gmail address');
      return false;
    }

    if (authPassword.isEmpty || authPassword.length < 4) {
      buildScaffoldErrorMessage(context, 'Password must be at least 4 letters');
      return false;
    }

    return true;
  }

  Future<void> deleteAccount(BuildContext context) async {
    Get.defaultDialog(
      title: AppConstants.deleteAccountTitle,
      middleText: AppConstants.deleteAccountConfirmationMessage,
      textCancel: AppConstants.cancel,
      textConfirm: AppConstants.confirm,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        try {
          isLoading.value = true;

          User? currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            String userId = currentUser.uid;

            AuthCredential credential = EmailAuthProvider.credential(
              email: currentUser.email!,
              password: UsersStorageService.getPassword().toString(),
            );

            await currentUser.reauthenticateWithCredential(credential);
            await currentUser.delete();
            await FirebaseFirestore.instance
                .collection(AppConstants.collectionAuth)
                .doc(userId)
                .delete();

            UsersStorageService.clearUserData();
            isLoading.value = false;

            buildScaffoldSuccessMessage(
                context, AppConstants.accountDeletedSuccess);

            Get.offAllNamed(AppRouter.LOGIN_SCREEN);
          } else {
            isLoading.value = false;
            buildScaffoldErrorMessage(context, AppConstants.noUserToDelete);
          }
        } catch (e) {
          isLoading.value = false;
          buildScaffoldErrorMessage(
              context, '${AppConstants.failedToDeleteAccount} $e');
        }
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  //-------------------------------CHANGE_PASSWORD_IN_FIRESTORE--------------------//
  Future<void> changePassword(BuildContext context) async {
    if (await validateChangePasswordField(context)) {
      // Proceed with updating the password in Firebase Authentication and Firestore
      String authNewPassword = authNewPasswordController.text.trim();
      String authConfirmNewPassword =
      authConfirmNewPasswordController.text.trim();

      try {
        isLoading.value = true;

        // 1. Get the current user
        var user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // 2. Reauthenticate the user before changing the password
          // Optionally, add the current password for reauthentication (if needed)
          await user.reauthenticateWithCredential(EmailAuthProvider.credential(
            email: user.email!,
            password: authOldPasswordController.text
                .trim(), // Make sure to provide the current password
          ));

          // 3. Update password in Firebase Authentication
          await user.updatePassword(authNewPassword);

          // 4. Get the authId from UsersStorageService
          String authId = UsersStorageService.getUserId().toString();

          // 5. Update password and confirm password in Firestore
          await firebaseFirestore
              .collection(AppConstants.collectionAuth)
              .doc(authId)
              .update({
            "authPassword": authNewPassword,
            "authConfirmPassword":
            authConfirmNewPassword, // Add the confirm password here
          });

          isLoading.value = false;

          // Show success message
          buildScaffoldSuccessMessage(
              context, 'Password updated successfully!');
          clearChangePasswordController();
          Get.back();
        } else {
          isLoading.value = false;
          buildScaffoldErrorMessage(
              context, 'User not authenticated. Please log in again.');
        }
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        // Handle Firebase-specific authentication errors
        buildScaffoldErrorMessage(
            context, 'Failed to update password: ${e.message}');
        print("Firebase Auth Error: ${e.message}");
      } catch (e) {
        isLoading.value = false;
        // Handle generic errors
        buildScaffoldErrorMessage(
            context, 'Failed to update password. Please try again.');
        print("Error updating password: $e");
      }
    }
  }

//---------VALIDATE_CHANGE_PASSWORD
  validateChangePasswordField(BuildContext context) async {
    print("validate field click");
    String authOldPassword = authOldPasswordController.text.trim();
    String authNewPassword = authNewPasswordController.text.trim();
    String authConfirmNewPassword =
    authConfirmNewPasswordController.text.trim();

    if (authOldPassword.isEmpty) {
      buildScaffoldErrorMessage(context, 'Please enter Your Old Password');
      return false;
    } else {
      String firestorePassword = await fetchFirestorePassword('authPassword');

      if (firestorePassword != authOldPassword) {
        buildScaffoldErrorMessage(context, 'Old password is incorrect');
        print('Old password entered: $authOldPassword');
        print('Password from Firestore: $firestorePassword');
        return false;
      }
    }

    if (authNewPassword.isEmpty) {
      buildScaffoldErrorMessage(context, 'Please enter New Password');
      return false;
    } else if (authNewPassword.length < 4) {
      buildScaffoldErrorMessage(
          context, 'Password must be at least 4 characters long');
      return false;
    } else if (authNewPassword == authOldPassword) {
      print("New Password is : $authNewPassword");
      buildScaffoldErrorMessage(
          context, 'New password cannot be the same as the old password');
      print(
          'New password:$authNewPassword cannot be the same as the old password:$authOldPassword');
      return false;
    }

    if (authConfirmNewPassword.isEmpty) {
      buildScaffoldErrorMessage(context, 'Please enter Confirm Password');
      return false;
    } else if (authConfirmNewPassword.length < 4) {
      buildScaffoldErrorMessage(
          context, 'Password must be at least 4 characters long');
      return false;
    }

    if (authNewPassword != authConfirmNewPassword) {
      buildScaffoldErrorMessage(
          context, 'New Password and Confirm Password do not match');
      return false;
    }

    return true;
  }

  /// -------- Check Firestore password and user-entered password -------- //
  Future<String> fetchFirestorePassword(String field) async {
    // Get the user ID from storage
    var authId = UsersStorageService.getUserId();

    // Retrieve the document for the user from the specified Firestore collection
    final snapshot = await FirebaseFirestore.instance
        .collection(
        AppConstants.collectionAuth) // Use the appropriate collection
        .doc(authId) // Use the user ID to locate the document
        .get();

    // Return the value of the specified field (e.g., authPassword)
    return snapshot[field];
  }

//----AFTER CHANGING THE FIELD MUST BE CLEAR
  void clearChangePasswordController() {
    authOldPasswordController.clear();
    authNewPasswordController.clear();
    authConfirmNewPasswordController.clear();
  }

  void clearLoginControllers() {
    authLoginEmailAddressController.clear();
    authLoginPasswordController.clear();
  }
}




String getErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Invalid password. Please try again.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'invalid-email':
        return 'The email address is not valid.';
      default:
        return 'An unknown error occurred. Please try again.';
    }
  }
  return 'An unexpected error occurred.';
}
