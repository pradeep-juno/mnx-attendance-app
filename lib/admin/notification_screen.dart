import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_controller/admin_controller.dart';
import 'leave_approval.dart';

class AdminNotificationScreen extends StatefulWidget {
  @override
  State<AdminNotificationScreen> createState() => _AdminNotificationScreenState();
}

class _AdminNotificationScreenState extends State<AdminNotificationScreen> {
  final AdminMessageController adminController = Get.put(AdminMessageController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // This shows hamburger menu instead of back button
        title: Text('Dashboard'),
      ),
   body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Form(
    key: _formKey,
    child: Column(
    children: [
    Obx(() => TextFormField(
    initialValue: adminController.headerController.value,
    onChanged: (value) => adminController.headerController.value = value,
    decoration: InputDecoration(
    labelText: 'Enter Notification Title',
    border: OutlineInputBorder(),
    ),
    validator: (value) =>
    value == null || value.trim().isEmpty ? 'Header cannot be empty' : null,
    )),
    SizedBox(height: 16),
    Obx(() => TextFormField(
    maxLines: 5,
    initialValue: adminController.bodyController.value,
    onChanged: (value) => adminController.bodyController.value = value,
    decoration: InputDecoration(
    labelText: 'Enter Notification Message',
    border: OutlineInputBorder(),
    ),
    validator: (value) =>
    value == null || value.trim().isEmpty ? 'Body cannot be empty' : null,
    )),
    SizedBox(height: 20),
    ElevatedButton.icon(
    icon: Icon(Icons.send),
    label: Text('Send Message'),
    onPressed: () {
    if (_formKey.currentState!.validate()) {
    adminController.sendMessage();
    }
    },
    ),
    ],
    ),
    ),
    ),
    );
  }
}










