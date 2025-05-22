import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_controller/admin_controller.dart';
import 'leave_approval.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminMessageController adminController = Get.put(AdminMessageController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Navigation', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
               Get.back(); // Just close drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.event_note),
              title: Text('Leave Requests'),
              onTap: () {
                Get.off(() => LeaveRequestScreen()); // Navigate fresh
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
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










