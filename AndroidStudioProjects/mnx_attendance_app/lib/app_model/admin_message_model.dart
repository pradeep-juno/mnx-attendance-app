class AdminMessageModel {
  final String header;
  final String message;
  final DateTime timestamp;
  final String? adminMessageId;
  bool isRead;

  AdminMessageModel({
    required this.header,
    required this.message,
    required this.timestamp,
    this.adminMessageId,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'header': header,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory AdminMessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return AdminMessageModel(
      header: map['header'] ?? '',
      message: map['message'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      adminMessageId: docId,
      isRead: map['isRead'] ?? false,
    );
  }

  @override
  String toString() {
    return 'AdminMessageModel(header: $header, message: $message, timestamp: $timestamp, adminMessageId: $adminMessageId , isRead: $isRead)';
  }
}
