import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mnx_attendance_app/app_controller/clockIn_ClockOut_Controller.dart';

import '../../app_model/clockIn_clockOut_model.dart';

class MissedAttendanceScreen extends StatefulWidget {
  const MissedAttendanceScreen({super.key});

  @override
  State<MissedAttendanceScreen> createState() => _MissedAttendanceScreenState();
}

class _MissedAttendanceScreenState extends State<MissedAttendanceScreen> {
  ClockInClockOutController clockInClockOutController = Get.put(ClockInClockOutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Missed Attendance")),
      body: FutureBuilder(
        future: clockInClockOutController.getMissedAttendanceRecords(
          DateTime.now().subtract(const Duration(days: 7)),
          DateTime.now(),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(child: Text("No missed attendance"));
          }

          final records = snapshot.data as List<ClockModel>;
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (_, index) {
              final rec = records[index];
              final missedDate = rec.clockInTime ?? rec.clockOutTime!;
              final missedType = (rec.clockInTime == null && rec.clockOutTime != null)
                  ? "Missed Clock-In"
                  : (rec.clockOutTime == null && rec.clockInTime != null)
                  ? "Missed Clock-Out"
                  : "Attendance Missing";

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Box
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.d().format(missedDate),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat.MMM().format(missedDate),
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Missed Attendance",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$missedType on this day",
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                DateFormat('hh:mm a, MMM dd, yyyy').format(missedDate),
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
