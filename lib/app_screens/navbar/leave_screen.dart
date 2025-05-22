import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app_controller/leave_Controler.dart';
import '../../app_utils/app_constants.dart';


class LeaveScreen extends StatelessWidget {
  LeaveScreen({super.key});

  final LeaveController controller = Get.put(LeaveController());


  Future<void> _pickDate(bool isStart, BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? controller.startDate.value : controller.endDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      if (isStart) {
        controller.setStartDate(pickedDate);
      } else {
        controller.setEndDate(pickedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeTextStyle = const TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 16,
      letterSpacing: 0.02,
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset('assets/icons/back.png', width: 24, height: 24),
                  ),
                  const SizedBox(width: 16),
                  Text(AppConstants.leaveRequest, style: themeTextStyle),
                ],
              ),
              const SizedBox(height: 24),

              Text(AppConstants.leaveType, style: themeTextStyle),
              const SizedBox(height: 8),
              LeaveTypeDropdown(),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppConstants.startDate, style: themeTextStyle),
                        const SizedBox(height: 8),
                        Obx(() => _datePickerBox(controller.startDate.value, () => _pickDate(true, context))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppConstants.endDate, style: themeTextStyle),
                        const SizedBox(height: 8),
                        Obx(() => _datePickerBox(controller.endDate.value, () => _pickDate(false, context))),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Text(AppConstants.halfDayLeave, style: themeTextStyle),
                  const SizedBox(width: 10),
                  HalfDayLeaveDropdown(),

                  const Spacer(),
                  Obx(() => Text(
                    "Total Leave: ${controller.totalLeaveDays.value}",
                    style: themeTextStyle,
                  )),
                ],
              ),

              const SizedBox(height: 16),
              Text(AppConstants.reason, style: themeTextStyle),
              const SizedBox(height: 8),

              Container(
                height: 120,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: controller.reasonController,
                  onChanged: (value) => controller.setReason(value),
                  maxLines: null,
                  decoration: const InputDecoration.collapsed(
                    hintText: AppConstants.reasonForLeave,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00125D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => controller.submitLeaveRequest(),
                  child: Text(
                    AppConstants.submit,
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _datePickerBox(DateTime date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(2, 2),
              blurRadius: 4,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(DateFormat('dd-MMM-yyyy').format(date)),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }
}


class LeaveTypeDropdown extends StatefulWidget {

  LeaveTypeDropdown({super.key});

  @override
  State<LeaveTypeDropdown> createState() => _LeaveTypeDropdownState();
}

class _LeaveTypeDropdownState extends State<LeaveTypeDropdown> {
  final LeaveController controller = Get.find();

  final List<String> leaveOptions = [
    "Annual Leave",
    "Sick Leave",
    "Compensational Leave",
    "Unpaid Leave"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: controller.selectedLeaveType.value.isEmpty
              ? null
              : controller.selectedLeaveType.value,
          hint: Text("Select Leave Type", style: TextStyle(color: Colors.grey[600])),
          items: leaveOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) controller.setLeaveType(value);
          },
        ),
      )),
    );
  }
}

class HalfDayLeaveDropdown extends StatefulWidget {
  HalfDayLeaveDropdown({super.key});

  @override
  State<HalfDayLeaveDropdown> createState() => _HalfDayLeaveDropdownState();
}

class _HalfDayLeaveDropdownState extends State<HalfDayLeaveDropdown> {
  final LeaveController controller = Get.find();

  final List<int> leaveDurations = [0,2, 3, 4, 5, 6]; // only the numbers

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: controller.offDayLeaveDuration.value,
          hint: Text("Select Duration", style: TextStyle(color: Colors.grey[600])),
          items: leaveDurations.map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text("$value Hrs"),
            );
          }).toList(),
          onChanged: (int? newValue) {
            if (newValue != null) {
              controller.setOffDayLeaveDuration(newValue); // this sets the int
            }
          },
        ),
      )),
    );
  }
}

