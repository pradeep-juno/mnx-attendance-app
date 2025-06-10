import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../app_controller/leave_Controler.dart';
import '../app_utils/app_colors.dart'; // Assuming you have theme colors

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
  final List<String> statuses = ['Pending', 'Approved', 'Rejected'];

  @override
  void initState() {
    super.initState();
    leaveController.fetchLeaveRequests();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: AppColors.backgroundWhite,),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Leave Approvals',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.backgroundWhite
            ),
          ),
          backgroundColor: const Color(0xFF00156A),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Row
              Row(
                children: [
                  const Text(
                    'Filter by status:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
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
      
              const SizedBox(height: 16),
      
              // List of Requests
              Expanded(
                child: Obx(() {
                  final filteredLeaves = leaveController.leaveRequests
                      .where((leave) => leave?.leaveStatus == statusFilter)
                      .toList();
      
                  if (filteredLeaves.isEmpty) {
                    return const Center(
                      child: Text(
                        'No leave requests found.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
      
                  return ListView.separated(
                    itemCount: filteredLeaves.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final leave = filteredLeaves[index];
      
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${leave.userName} • ${leave.leaveType}',
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 12,
                                runSpacing: 6,
                                children: [
                                  _buildInfoTag('From', formatDate(leave.startDate)),
                                  _buildInfoTag('To', formatDate(leave.endDate)),
                                  _buildInfoTag('Reason', leave.reason ?? "-"),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (leave.leaveStatus == 'Pending')
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.check, size: 18,color: AppColors.primaryColor,),
                                      label: const Text("Approve",style: TextStyle(color: AppColors.primaryColor),),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      onPressed: () {
                                        leaveController.updateLeaveStatus(leave.id, 'Approved');
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.close, size: 18,color: AppColors.primaryColor,),
                                      label: const Text("Reject",style: TextStyle(color: AppColors.primaryColor),),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () {
                                        leaveController.updateLeaveStatus(leave.id, 'Rejected');
                                      },
                                    ),
                                  ],
                                )
                              else
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: leave.leaveStatus == 'Approved'
                                          ? Colors.green[100]
                                          : Colors.red[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      leave.leaveStatus,
                                      style: TextStyle(
                                        color: leave.leaveStatus == 'Approved'
                                            ? Colors.green[800]
                                            : Colors.red[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
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
      ),
    );
  }

  Widget _buildInfoTag(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Text(value),
      ],
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}
