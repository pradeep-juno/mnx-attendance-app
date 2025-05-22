import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mnx_attendance_app/admin/settings_screen.dart';

import '../app_controller/leave_Controler.dart';
import '../app_router/app_router.dart';
import '../app_screens/navbar/dashboard_screen.dart';



void main() => runApp(LeaveApp());

class LeaveApp extends StatefulWidget {
  @override
  State<LeaveApp> createState() => _LeaveAppState();
}

class _LeaveAppState extends State<LeaveApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LeaveRequestScreen(),
    );
  }
}

class LeaveRequestScreen extends StatefulWidget {
  @override
  _LeaveRequestScreenState createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {

  final LeaveController leaveController = Get.put(LeaveController());

  String statusFilter = 'Pending';

  List<String> statuses = ['Pending', 'Approved', 'Rejected'];

  @override
  void initState() {
    super.initState();
    leaveController.fetchLeaveRequests();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: InkWell
                (
                onTap: () {
                  Get.toNamed(AppRouter.MAIN_NAVIGATION);
                },
                  child: Text('Navigation', style: TextStyle(color: Colors.white, fontSize: 24))),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Get.to(DashboardScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.event_note),
              title: Text('Leave Requests'),
              onTap: () {
                Get.back(); // Close drawer first
                Get.off(() => LeaveRequestScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Get.to(SettingsScreen());
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Leave Approvals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Status: '),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: statusFilter,
                  items: statuses.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      statusFilter = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            Expanded(
              child: Obx(() {
                // Filter leave requests by selected status
                final filteredLeaves = leaveController.leaveRequests
                    .where((leave) => leave?.leaveStatus == statusFilter)
                    .toList();

                // Show message if no matching data
                if (filteredLeaves.isEmpty) {
                  return Center(
                    child: Text(
                      'No data',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                // Build list if data exists
                return ListView.builder(
                  itemCount: filteredLeaves.length,
                  itemBuilder: (context, index) {
                    final leave = filteredLeaves[index];

                    return Card(
                      child: ListTile(
                        title: Text('${leave.userName} - ${leave.leaveType}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('From: ${leave.startDate.toLocal()}'),
                            Text('To: ${leave.endDate.toLocal()}'),
                            Text('Reason: ${leave.reason}'),
                            Text('Status: ${leave.leaveStatus}'),
                          ],
                        ),
                        trailing: leave.leaveStatus == 'Pending'
                            ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                leaveController.updateLeaveStatus(leave.id, 'Approved');
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                leaveController.updateLeaveStatus(leave.id, 'Rejected');
                              },
                            ),
                          ],
                        )
                            : Text(
                          leave.leaveStatus,
                          style: TextStyle(
                            color: leave.leaveStatus == 'Approved'
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day}-${months[date.month - 1]}-${date.year}';
  }

}