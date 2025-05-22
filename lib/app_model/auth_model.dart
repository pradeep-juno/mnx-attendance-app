class AuthModel {
  String authId;
  String authName;
  String authMobileNumber;
  String authEmailAddress;
  String authPassword;
  String authConfirmPassword;
  String position; // 👈 New field

  // Constructor
  AuthModel({
    required this.authId,
    required this.authName,
    required this.authMobileNumber,
    required this.authEmailAddress,
    required this.authPassword,
    required this.authConfirmPassword,
    required this.position, // 👈 Include in constructor
  });

  // From Map constructor
  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      authId: map['authId'] ?? '',
      authName: map['authName'] ?? '',
      authMobileNumber: map['authMobileNumber'] ?? '',
      authEmailAddress: map['authEmailAddress'] ?? '',
      authPassword: map['authPassword'] ?? '',
      authConfirmPassword: map['authConfirmPassword'] ?? '',
      position: map['position'] ?? '', // 👈 Include here
    );
  }

  // To Map method
  Map<String, dynamic> toMap() {
    return {
      'authId': authId,
      'authName': authName,
      'authMobileNumber': authMobileNumber,
      'authEmailAddress': authEmailAddress,
      'authPassword': authPassword,
      'authConfirmPassword': authConfirmPassword,
      'position': position, // 👈 Include here
    };
  }

  // To String method
  @override
  String toString() {
    return 'AuthModel{authId: $authId, authName: $authName, authMobileNumber: $authMobileNumber, authEmailAddress: $authEmailAddress, authPassword: $authPassword, authConfirmPassword: $authConfirmPassword, position: $position}';
  }
}
