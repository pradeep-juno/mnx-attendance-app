import 'package:get_storage/get_storage.dart';

class UsersStorageService {
  static final box = GetStorage();

  // Users
  static const String userIDKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String userMobileNumberKey = 'user_mobile_number';
  static const String userEmailKey = 'user_email';
  static const String userPasswordKey = 'user_password';
  static const String userPositionKey = 'user_position'; // 👈 Changed key

  static saveUser(String userId, String userName, String userMobileNumber,
      String userEmail, String userPassword, String userPosition) async {
    try {
      print('Saving User Data');
      await box.write(userIDKey, userId);
      await box.write(userNameKey, userName);
      await box.write(userMobileNumberKey, userMobileNumber);
      await box.write(userEmailKey, userEmail);
      await box.write(userPasswordKey, userPassword);
      await box.write(userPositionKey, userPosition); // 👈 Save position
      print('User Data saved successfully');

      print("User Id : $userId");
      print("User Name : $userName");
      print("User Mobile Number : $userMobileNumber");
      print("User Email : $userEmail");
      print("User Password : $userPassword");
      print("User Position : $userPosition");
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

  static clearUserData() async {
    try {
      print("Clearing stored user data...");

      await box.remove(userIDKey);
      await box.remove(userNameKey);
      await box.remove(userMobileNumberKey);
      await box.remove(userEmailKey);
      await box.remove(userPasswordKey);
      await box.remove(userPositionKey); // 👈 Remove position

      print('User Data cleared successfully');
    } catch (e) {
      print('Error clearing User Data: $e');
    }
  }
}
