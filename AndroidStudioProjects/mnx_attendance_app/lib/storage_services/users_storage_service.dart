// lib/services/users_storage_service.dart
import 'package:get_storage/get_storage.dart';

class UsersStorageService {
  static final box = GetStorage();

  // Users
  static const String userIDKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String userMobileNumberKey = 'user_mobile_number';
  static const String userEmailKey = 'user_email';
  static const String userPasswordKey = 'user_password';
  static const String userPositionKey = 'user_position';

  // Clock-in/out session keys
  static const String isClockInDoneKey = 'is_clock_in_done';
  static const String currentClockLogIdKey = 'current_clock_log_id';


  static Future<void> saveUser(String userId, String userName, String userMobileNumber,
      String userEmail, String userPassword, String userPosition) async {
    try {
      print('Saving User Data');
      await box.write(userIDKey, userId);
      await box.write(userNameKey, userName);
      await box.write(userMobileNumberKey, userMobileNumber);
      await box.write(userEmailKey, userEmail);
      await box.write(userPasswordKey, userPassword);
      await box.write(userPositionKey, userPosition);
      print('User Data saved successfully');
      print("User Id : $userId");
      print("User Name : $userName");
      // ... rest of prints
    } catch (e) {
      print('Error saving User Data: $e');
    }
  }

  static String? getUserId() {
    try {
      String? userId = box.read(userIDKey);
      print('Getting UserId: $userId');
      return userId;
    } catch (e) {
      print('Error getting UserId: $e');
      return null;
    }
  }

  static String? getUserName() {
    try {
      String? userName = box.read(userNameKey);
      print('Getting UserName: $userName');
      return userName;
    } catch (e) {
      print('Error getting UserName: $e');
      return null;
    }
  }

  // --- New methods for clock-in/out state ---
  static Future<void> saveClockInStatus(bool status) async {
    await box.write(isClockInDoneKey, status);
  }

  static bool isClockedIn() {
    return box.read(isClockInDoneKey) ?? false;
  }

  static Future<void> saveCurrentClockLogId(String? clockLogId) async {
    if (clockLogId == null) {
      await box.remove(currentClockLogIdKey);
    } else {
      await box.write(currentClockLogIdKey, clockLogId);
    }
  }

  static String? getCurrentClockLogId() {
    return box.read(currentClockLogIdKey);
  }

  static Future<void> clearUserData() async {
    try {
      print("Clearing stored user data...");
      await box.remove(userIDKey);
      await box.remove(userNameKey);
      await box.remove(userMobileNumberKey);
      await box.remove(userEmailKey);
      await box.remove(userPasswordKey);
      await box.remove(userPositionKey);
      await box.remove(isClockInDoneKey); // Clear clock-in state too
      await box.remove(currentClockLogIdKey); // Clear clock log ID
      print('User Data cleared successfully');
    } catch (e) {
      print('Error clearing User Data: $e');
    }
  }

  static String? getPassword() {
    try {
      String? userPassword = box.read(userPasswordKey);
      print('Getting UserPassword: $userPassword');
      return userPassword;
    } catch (e) {
      print('Error getting UserPassword: $e');
      return null;
    }
  }

  static String? getUserPosition() {
    try {
      String? userPosition = box.read(userPositionKey);
      print('Getting UserPosition: $userPosition');
      return userPosition;
    } catch (e) {
      print('Error getting UserPosition: $e');
      return null;
    }
  }
}