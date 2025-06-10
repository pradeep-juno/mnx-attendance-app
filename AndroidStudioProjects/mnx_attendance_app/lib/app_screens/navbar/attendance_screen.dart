import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app_controller/clockIn_ClockOut_Controller.dart';
import '../../app_controller/leave_Controler.dart'; // Corrected import
import '../../app_utils/app_colors.dart';
import '../../app_utils/app_constants.dart';
import '../../app_model/clockIn_clockOut_model.dart';
import '../../app_model/leave_model.dart';
import '../../storage_services/users_storage_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  int touchedIndex = -1;
  final ClockInClockOutController _clockController = Get.find<ClockInClockOutController>();
  final LeaveController _leaveController = Get.find<LeaveController>();
  List<Map<String, dynamic>> finalDailyDetails = [];

  String? _currentUserId;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  List<ClockModel> _weeklyAttendanceRecords = [];
  List<LeaveModel> _approvedLeaveRecords = [];


  List<Map<String, dynamic>> _buildFinalDailyDetails() {
    List<Map<String, dynamic>> details = [];
    Set<String> addedDates = {};

    // Add attendance records
    for (var record in _weeklyAttendanceRecords) {
      final date = DateTime(record.clockInTime.year, record.clockInTime.month, record.clockInTime.day);
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      addedDates.add(formattedDate);

      details.add({
        'date': date,
        'type': 'attendance',
        'status': _clockController.getAttendanceStatus(record),
        'record': record,
      });
    }

    // Add leave records
    for (var leave in _approvedLeaveRecords) {
      for (DateTime d = leave.startDate;
      !d.isAfter(leave.endDate);
      d = d.add(const Duration(days: 1))) {
        final normalized = DateTime(d.year, d.month, d.day);
        if (_startDate.isAfter(normalized) || _endDate.isBefore(normalized)) continue;
        details.add({
          'date': normalized,
          'type': 'leave',
          'status': 'Leave',
          'record': leave,
          'leaveType': leave.leaveType,
        });
      }
    }
    // Fill remaining dates as absent
    for (DateTime d = _startDate;
    !d.isAfter(_endDate);
    d = d.add(const Duration(days: 1))) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(d);
      if (!addedDates.contains(formattedDate)) {
        details.add({
          'date': d,
          'type': 'absent',
          'status': 'Absent',
        });
      }
    }
    // Sort by date
    details.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
    return details;
  }

  Map<String, int> _attendanceSummary = {
    'Present': 0,
    'Late Arrival': 0,
    'Early Departure': 0,
    'Over Time': 0,
    'Holiday': 0,
    'Holiday Working': 0,
    'Leave': 0,
    'Absent': 0,
  };
  // Declare a Worker to hold the listener, so it can be disposed
  late Worker _leaveRequestsWorker; // <-- ADD THIS LINE
  @override
  void initState() {
    super.initState();
    _initializeUserAndDates();

    // --- ADD THIS BLOCK ---
    // This listener will trigger _fetchAttendanceAndLeaveData
    // whenever the leaveRequests list in LeaveController changes.
    _leaveRequestsWorker = ever(_leaveController.leaveRequests, (_) {
      if (mounted) {
        print(">>> AttendanceScreen: LeaveController's leaveRequests changed. Re-fetching data.");
        _fetchAttendanceAndLeaveData();
      }
    });
  }
  @override
  void dispose() {
    _leaveRequestsWorker.dispose(); // Dispose the listener to prevent memory leaks
    super.dispose();
  }
  void _initializeUserAndDates() {
    _currentUserId = UsersStorageService.getUserId();
    if (_currentUserId == null) {
      print("Error: User ID not found in storage. Cannot fetch attendance.");
      return;
    }
    _startDate = _findFirstDayOfWeek(DateTime.now());
    _endDate = _startDate.add(const Duration(days: 6));
    _fetchAttendanceAndLeaveData(); // Call a combined fetch method
  }

  DateTime _findFirstDayOfWeek(DateTime date) {
    DateTime firstDay = date.subtract(Duration(days: date.weekday - 1));
    return DateTime(firstDay.year, firstDay.month, firstDay.day);
  }

  Future<void> _fetchAttendanceAndLeaveData() async {
    if (_currentUserId == null) return;

    print("--- AttendanceScreen: _fetchAttendanceAndLeaveData called ---");
    print("Current User ID: $_currentUserId");
    print("Current Date Range: ${_startDate.toLocal().toIso8601String()} to ${_endDate.toLocal().toIso8601String()}");

    try {
      final clockRecords = await _clockController.getAttendanceRecordsForUser(
        userId: _currentUserId!,
        startDate: _startDate,
        endDate: _endDate,
      );
      print("Number of raw clock records fetched for range: ${clockRecords.length}");


      await _leaveController.fetchLeaveRequests(); // Ensure controller's data is fresh
      print("Total leave requests in LeaveController: ${_leaveController.leaveRequests.length}");

      final approvedLeaves = _leaveController.leaveRequests.where((leave) {
        final isApproved = leave.leaveStatus == 'Approved';
        // Check for overlap, allowing for leaves that start/end on the boundary days
        final isWithinRange = (
            leave.startDate.isBefore(_endDate.add(const Duration(days: 1))) &&
                leave.endDate.isAfter(_startDate.subtract(const Duration(days: 1)))
        );
        print("  Checking leave: ${leave.id}, Type: ${leave.leaveType}, Status: ${leave.leaveStatus}, Start: ${leave.startDate}, End: ${leave.endDate}");
        print("    Is Approved? $isApproved, Is Within Range? $isWithinRange");
        return isApproved && isWithinRange;
      }).toList();

      print("Number of FILTERED APPROVED leaves for current range: ${approvedLeaves.length}");
      if (approvedLeaves.isNotEmpty) {
        for (var leave in approvedLeaves) {
          print("  -> Approved Leave ID: ${leave.id}, Type: ${leave.leaveType}, Start: ${leave.startDate}, End: ${leave.endDate}");
        }
      }

      if (!mounted) return;
      setState(() {
        _weeklyAttendanceRecords = clockRecords;
        _approvedLeaveRecords = approvedLeaves;
        _calculateAttendanceSummary();
        finalDailyDetails = _buildFinalDailyDetails();
      });

    } catch (e) {
      Get.snackbar("Error", "Failed to fetch data: $e");
      print("Failed to fetch attendance or leave data: $e");
    }
  }

  void _calculateAttendanceSummary() {
    _attendanceSummary = {
      'Present': 0, 'Late Arrival': 0, 'Early Departure': 0, 'Over Time': 0,
      'Holiday': 0, 'Holiday Working': 0, 'Leave': 0, 'Absent': 0,
    };

    Set<DateTime> processedDates = {};

    for (var record in _weeklyAttendanceRecords) {
      DateTime normalizedDate = DateTime(record.clockInTime.year, record.clockInTime.month, record.clockInTime.day);
      if (normalizedDate.isAfter(_endDate) || normalizedDate.isBefore(_startDate)) continue;

      String status = _clockController.getAttendanceStatus(record);
      _attendanceSummary[status] = (_attendanceSummary[status] ?? 0) + 1;
      processedDates.add(normalizedDate);
    }

    for (var leave in _approvedLeaveRecords) {
      for (DateTime d = DateTime(leave.startDate.year, leave.startDate.month, leave.startDate.day);
      d.isBefore(DateTime(leave.endDate.year, leave.endDate.month, leave.endDate.day).add(const Duration(days: 1)));
      d = d.add(const Duration(days: 1)))
      {
        DateTime normalizedDate = DateTime(d.year, d.month, d.day);

        if (normalizedDate.isAfter(_endDate) || normalizedDate.isBefore(_startDate)) continue;

        if (!processedDates.contains(normalizedDate)) {
          _attendanceSummary['Leave'] = (_attendanceSummary['Leave'] ?? 0) + 1;
          processedDates.add(normalizedDate);
        }
      }
    }

    for (DateTime d = _startDate; d.isBefore(_endDate.add(const Duration(days: 1))); d = d.add(const Duration(days: 1))) {
      DateTime normalizedDate = DateTime(d.year, d.month, d.day);
      if (!processedDates.contains(normalizedDate)) {
        _attendanceSummary['Absent'] = (_attendanceSummary['Absent'] ?? 0) + 1;
      }
    }

    print("Final Attendance Summary: $_attendanceSummary");
  }


  Future<void> _selectDateRange() async {
    DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select Start Date',
    );

    if (pickedStartDate != null) {
      DateTime? pickedEndDate = await showDatePicker(
        context: context,
        initialDate: _endDate,
        firstDate: pickedStartDate,
        lastDate: DateTime(2030),
        helpText: 'Select End Date',
      );

      if (pickedEndDate != null) {
        setState(() {
          _startDate = DateTime(pickedStartDate.year, pickedStartDate.month, pickedStartDate.day);
          _endDate = DateTime(pickedEndDate.year, pickedEndDate.month, pickedEndDate.day);
        });
        _fetchAttendanceAndLeaveData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backGroundColor.withAlpha(50),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Image.asset(
                              'assets/icons/back.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                          AttendanceHeader(name: AppConstants.weeklyAttendance),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Start Date Picker
                          GestureDetector(
                            onTap: _selectDateRange,
                            child: Container(
                              height: 41,
                              width: 142,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                color: AppColors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset("assets/icons/calender.png", height: 14, width: 14),
                                  Text(
                                    DateFormat('dd-MMM-yyyy').format(_startDate),
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      height: 1.0,
                                      letterSpacing: 0.0,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  Image.asset("assets/icons/Drop Down.png", height: 21, width: 21),
                                ],
                              ),
                            ),
                          ),
                          // End Date Picker
                          GestureDetector(
                            onTap: _selectDateRange,
                            child: Container(
                              height: 41,
                              width: 142,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                color: AppColors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset("assets/icons/calender.png", height: 14, width: 14),
                                  Text(
                                    DateFormat('dd-MMM-yyyy').format(_endDate),
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      height: 1.0,
                                      letterSpacing: 0.0,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  Image.asset("assets/icons/Drop Down.png", height: 21, width: 21),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      /// >>>>> PIE CHART WITH CENTER TEXT <<<<<
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                                height: 250,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 70,
                                    startDegreeOffset: 270,
                                    sections: showingSections(),
                                    pieTouchData: PieTouchData(
                                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                        setState(() {
                                          if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                                            touchedIndex = -1;
                                            return;
                                          }
                                          touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                        });
                                      },
                                    ),
                                  ),
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.easeInOut,
                                )
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('dd-MMM-yyyy').format(DateTime.now()),
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${_attendanceSummary['Present'] ?? 0} ${AppConstants.present}",
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF4CAF50), // Present color
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// >>>>> LEGEND ITEMS <<<<<
                      Wrap(
                        spacing: 20,
                        runSpacing: 14,
                        children: _attendanceSummary.entries.map((entry) {
                          Color color;
                          switch (entry.key) {
                            case 'Present': color = const Color(0xFF4CAF50); break;
                            case 'Late Arrival': color = const Color(0xFFFF9800); break;
                            case 'Early Departure': color = const Color(0xFFFFC107); break;
                            case 'Over Time': color = const Color(0xFF2196F3); break;
                            case 'Holiday': color = const Color(0xFF80CBC4); break;
                            case 'Holiday Working': color = const Color(0xFF3F51B5); break;
                            case 'Leave': color = const Color(0xFF673AB7); break; // Leave color
                            case 'Absent': color = const Color(0xFFF44336); break;
                            default: color = Colors.grey;
                          }
                          return legendItem(color, "${entry.key} (${entry.value})");
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      /// >>>>> LISTVIEW BUILDER (Daily Attendance Details) <<<<<
                      const Text(
                        "Daily Details",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Combine and display daily records and approved leaves
                      _buildDailyDetailsList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the combined daily details list
  Widget _buildDailyDetailsList() {
    Map<DateTime, Map<String, dynamic>> dailyCombinedRecords = {};

    for (var record in _weeklyAttendanceRecords) {
      DateTime normalizedDate = DateTime(record.clockInTime.year, record.clockInTime.month, record.clockInTime.day);
      if (normalizedDate.isAfter(_endDate) || normalizedDate.isBefore(_startDate)) continue;

      dailyCombinedRecords[normalizedDate] = {
        'type': 'attendance',
        'record': record,
        'status': _clockController.getAttendanceStatus(record),
      };
    }

    for (var leave in _approvedLeaveRecords) {
      for (DateTime d = DateTime(leave.startDate.year, leave.startDate.month, leave.startDate.day);
      d.isBefore(DateTime(leave.endDate.year, leave.endDate.month, leave.endDate.day).add(const Duration(days: 1)));
      d = d.add(const Duration(days: 1)))
      {
        DateTime normalizedDate = DateTime(d.year, d.month, d.day);
        if (normalizedDate.isAfter(_endDate) || normalizedDate.isBefore(_startDate)) continue;

        if (!dailyCombinedRecords.containsKey(normalizedDate) ||
            dailyCombinedRecords[normalizedDate]!['status'] == 'Absent') {
          dailyCombinedRecords[normalizedDate] = {
            'type': 'leave',
            'record': leave,
            'status': 'Leave',
            'leaveType': leave.leaveType,
          };
        }
      }
    }

    List<DateTime> allDatesInRange = [];
    for (DateTime d = _startDate; d.isBefore(_endDate.add(const Duration(days: 1))); d = d.add(const Duration(days: 1))) {
      allDatesInRange.add(DateTime(d.year, d.month, d.day));

    }
    allDatesInRange.sort((a,b) => a.compareTo(b));

    List<Map<String, dynamic>> finalDailyDetails = [];
    for (DateTime date in allDatesInRange) {
      if (dailyCombinedRecords.containsKey(date)) {
        finalDailyDetails.add(dailyCombinedRecords[date]!);
      } else {
        finalDailyDetails.add({
          'type': 'absent',
          'date': date,
          'status': 'Absent',
        });
      }
    }

    if (finalDailyDetails.isEmpty) {
      return const Center(child: Text("No attendance or leave records found for this period."));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: finalDailyDetails.length,
      itemBuilder: (context, index) {
        final entry = finalDailyDetails[index];
        final entryDate = entry['type'] == 'absent' ? entry['date'] : (entry['type'] == 'attendance' ? (entry['record'] as ClockModel).clockInTime : (entry['record'] as LeaveModel).startDate);
        final displayDate = DateFormat('EEEE, dd MMM').format(entryDate);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text("Status: ${entry['status']}"),
                if (entry['type'] == 'attendance') ...[
                  Text("Check-in Location: ${(entry['record'] as ClockModel).location}"),
                  Text("Check-in: ${DateFormat('hh:mm a').format((entry['record'] as ClockModel).clockInTime)}"),
                  if ((entry['record'] as ClockModel).clockOutTime != null)
                    Text("Check-out: ${DateFormat('hh:mm a').format((entry['record'] as ClockModel).clockOutTime!)}"),
                  if ((entry['record'] as ClockModel).locationOut != null)
                    Text("Check-out Location: ${(entry['record'] as ClockModel).locationOut!}"),
                ] else if (entry['type'] == 'leave') ...[
                  Text("Leave Type: ${entry['leaveType']}"),
                  Text("Reason: ${(entry['record'] as LeaveModel).reason}"),
                  Text("Leave Duration: ${DateFormat('dd-MMM-yyyy').format((entry['record'] as LeaveModel).startDate)} - ${DateFormat('dd-MMM-yyyy').format((entry['record'] as LeaveModel).endDate)}"),
                ] else if (entry['type'] == 'absent') ...[
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> showingSections() {
    final Map<String, Color> statusColors = {
      'Present': const Color(0xFF4CAF50),
      'Late Arrival': const Color(0xFFFF9800),
      'Early Departure': const Color(0xFFFFC107),
      'Over Time': const Color(0xFF2196F3),
      'Holiday': const Color(0xFF80CBC4),
      'Holiday Working': const Color(0xFF3F51B5),
      'Leave': const Color(0xFF673AB7),
      'Absent': const Color(0xFFF44336),
    };

    List<PieChartSectionData> sections = [];
    _attendanceSummary.forEach((status, count) {
      if (count > 0) {
        final isTouched = statusColors.keys.toList().indexOf(status) == touchedIndex;
        final double radius = isTouched ? 50 : 40;
        final double fontSize = isTouched ? 16 : 12;
        final FontWeight fontWeight = isTouched ? FontWeight.bold : FontWeight.normal;

        sections.add(
          PieChartSectionData(
            color: statusColors[status] ?? Colors.grey,
            value: count.toDouble(),
            title: isTouched ? '${count} \n ${status}' : '',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.white,
            ),
            titlePositionPercentageOffset: 0.55,
          ),
        );
      }
    });

    if (sections.isEmpty) {
      sections.add(
        PieChartSectionData(
          color: Colors.grey,
          value: 100,
          title: 'No Data',
          radius: 40,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
    return sections;
  }

  Widget legendItem(Color color, String text) {
    return SizedBox(
      width: 130,
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceHeader extends StatelessWidget {
  final String name;

  const AttendanceHeader({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}