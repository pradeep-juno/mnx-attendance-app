class ClockModel {
  final String clockId;
  final String uId;
  final String userName;
  final String location;
  final DateTime clockInTime;
  final DateTime? clockOutTime;

  ClockModel({
    required this.clockId,
    required this.uId,
    required this.userName,
    required this.location,
    required this.clockInTime,
    this.clockOutTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'clockId': clockId,
      'uId': uId,
      'userName': userName,
      'location': location,
      'clockInTime': clockInTime.toIso8601String(),
      'clockOutTime': clockOutTime,
    };
  }


  factory ClockModel.fromMap(Map<String, dynamic> map, String docId) {
    return ClockModel(
      clockId: docId,
      uId: map['uId'] ?? '',
      userName: map['userName'] ?? '',
      location: map['location'] ?? '',
      clockInTime: DateTime.parse(map['clockInTime'] ?? ''),
      clockOutTime: map['clockOutTime'] != null
          ? DateTime.parse(map['clockOutTime'])
          : null,
    );
  }

  @override
  String toString() {
    return 'ClockModel(clockId: $clockId, uId: $uId, userName: $userName, location: $location, clockInTime: $clockInTime, clockOutTime: $clockOutTime)';
  }
}
