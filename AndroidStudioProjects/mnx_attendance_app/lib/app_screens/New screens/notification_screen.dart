import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_controller/admin_controller.dart';
import '../../app_utils/app_colors.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final AdminMessageController adminMessageController = Get.put(
    AdminMessageController(),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Image.asset("assets/icons/back.png", height: 32, width: 32),
          ),

          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              height: 1.0,
              // 100% line height
              letterSpacing: 0.32,
              // 2% of 16px
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack.withValues(alpha: 0.9),
            ),
          ),
        ),
        body: Obx(() {
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: adminMessageController.messages.length,
            itemBuilder: (context, index) {
              final message = adminMessageController.messages[index];
              return NotificationCard(
                header: message.header,
                message: message.message,
                timestamp: message.timestamp,
                isRead: message.isRead,
                onTap: () {
                  if (!message.isRead && message.adminMessageId != null) {
                    FirebaseFirestore.instance
                        .collection('adminMessages')
                        .doc(message.adminMessageId)
                        .update({'isRead': true});
                    message.isRead = true; // Update locally
                    adminMessageController.messages.refresh(); // Refresh UI
                  }
                },
              );
            },

          );
        }),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String header;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.header,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final date = "${timestamp.day}";
    final month = _getMonthName(timestamp.month);
    final formattedTime =
        "${_formatTime(timestamp)} $month ${timestamp.day}, ${timestamp.year}";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left date box
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      month,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Right content
            Expanded(
              child: SizedBox(
                height: 92,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            header,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (!isRead) // Show "New" only if it's unread
                          Container(
                            width: 64,
                            height: 19,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00126A),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'New',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black87),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        formattedTime,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime time) {
    int hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? "PM" : "AM";
    hour = hour % 12 == 0 ? 12 : hour % 12;
    return "$hour:$minute $period";
  }
}

