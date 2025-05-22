import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveModel {
  final String id;
  final String leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final int offDayLeaveDuration;
  final String reason;
  final int totalDays;
  final String uId;
  final String userName;
  final DateTime leaveCreatedDate;
  final String leaveStatus;

  LeaveModel({
    required this.id,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.offDayLeaveDuration,
    required this.reason,
    required this.totalDays,
    required this.uId,
    required this.userName,
    required this.leaveCreatedDate,
    required this.leaveStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'leaveType': leaveType,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'offDayLeaveDuration': offDayLeaveDuration,
      'reason': reason,
      'totalDays': totalDays,
      'uId': uId,
      'userName': userName,
      'leaveCreatedDate': Timestamp.fromDate(leaveCreatedDate),
      'leaveStatus': leaveStatus,
    };
  }

  factory LeaveModel.fromMap(Map<String, dynamic> map, String docId) {
    return LeaveModel(
      id: docId,
      leaveType: map['leaveType'] ?? '',
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      offDayLeaveDuration: map['offDayLeaveDuration'] ?? 2,
      reason: map['reason'] ?? '',
      totalDays: map['totalDays'] ?? 0,
      uId: map['uId'] ?? '',
      userName: map['userName'] ?? '',
      leaveCreatedDate: (map['leaveCreatedDate'] as Timestamp).toDate(),
      leaveStatus: (map['leaveStatus'] ?? '').toString().isEmpty ? 'Pending' : map['leaveStatus'],

    );
  }

  @override
  String toString() {
    return 'LeaveModel(id: $id, leaveType: $leaveType, startDate: $startDate, endDate: $endDate, '
        'offDayLeaveDuration: $offDayLeaveDuration, reason: $reason, totalDays: $totalDays, '
        'uId: $uId, userName: $userName, leaveCreatedDate: $leaveCreatedDate, leaveStatus: $leaveStatus)';
  }
}
