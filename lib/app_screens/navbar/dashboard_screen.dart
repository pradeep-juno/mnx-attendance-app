import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app_controller/admin_controller.dart';
import '../../app_controller/clockIn_ClockOut_Controller.dart';
import '../../app_controller/leave_Controler.dart';
import '../../app_router/app_router.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/app_functions.dart';
import '../../storage_services/users_storage_service.dart';
import '../New screens/clockIn_Screen.dart';
import '../New screens/notification_screen.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final LeaveController leaveController = Get.put(LeaveController());
final ClockInClockOutController clockInClockcontroller = Get.put(ClockInClockOutController());
final AdminMessageController adminMessageController = Get.put(AdminMessageController());

  final String userName = UsersStorageService.getUserName() ?? 'User';
  final String position = UsersStorageService.getUserPosition() ?? 'Position';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.white, // optional, set your color
          actions: [
            InkWell(
              onTap: () {
                Get.to(() => NotificationListScreen());
              },
              child: Image.asset(
                "assets/icons/Notification.png",
                height: 20,
                width: 20,
              ),
            ),

            SizedBox(width: 16),
            InkWell(
              onTap: () {
                     Get.toNamed(AppRouter.PROFILE_SCREEN);
              },
                child: Image.asset("assets/icons/profile.png",height: 25,width: 25)),
            SizedBox(width: 16), // spacing from the edge
          ],
        ),
          body: SingleChildScrollView(
          child: Container(
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

                 Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widgetBuildText("Hi ${userName}", 18, FontWeight.bold, Colors.black),
                  const SizedBox(height: 10),
                  widgetBuildText(position , 14, FontWeight.normal, Colors.grey),
                ],
              ),
                const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Clock In Container
                      GestureDetector(
                        onTap: () {
                          if (clockInClockcontroller.clockInTime.value == null) {
                            // Navigate or open clock-in screen
                            Get.to(() => ClockInScreen(actionType: 'clock-in'));
                          }
                        },
                        child: Container(
                          height: 41,
                          width: 142,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            color: clockInClockcontroller.clockInTime.value == null
                                ? AppColors.white
                                : Colors.grey.shade200, // disable look if already clocked in
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset("assets/icons/clock out 2.png", height: 14, width: 14),
                              Obx(() {
                                final time = clockInClockcontroller.clockInTime.value;
                                final formattedTime = time != null
                                    ? DateFormat('hh:mm a').format(time)
                                    : "Not In";
                                return Text(
                                  formattedTime,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: AppColors.blue,
                                  ),
                                );
                              }),
                               Image.asset("assets/icons/Drop Down.png", height: 21, width: 21),
                            ],
                          ),
                        ),
                      ),

                      // Clock Out Container
                      GestureDetector(
                        onTap: () {
                          if (clockInClockcontroller.clockInTime.value != null &&
                              clockInClockcontroller.clockOutTime.value == null) {
                            // Only allow if clock-in is already done
                            Get.to(() => ClockInScreen(actionType: 'clock-out'));
                          }
                        },
                        child: Container(
                          height: 41,
                          width: 142,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            color: clockInClockcontroller.clockInTime.value != null &&
                                clockInClockcontroller.clockOutTime.value == null
                                ? AppColors.white
                                : Colors.grey.shade200, // disabled look if not allowed
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset("assets/icons/clock out 1.png", height: 14, width: 14),
                              Obx(() {
                                final time = clockInClockcontroller.clockOutTime.value;
                                final formattedTime = time != null
                                    ? DateFormat('hh:mm a').format(time)
                                    : "Not Out";
                                return Text(
                                  formattedTime,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: AppColors.blue,
                                  ),
                                );
                              }),
                              Image.asset("assets/icons/Drop Down.png", height: 21, width: 21),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 24),
                  Text(
                    AppConstants.quickInsights,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1.0, // 100% line height
                      letterSpacing: 0.0,
                      color: AppColors.textBlack.withValues(alpha: 80),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                           Get.toNamed(AppRouter.MISSED_ATTENDANCE_SCREEN);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: _buildQuickInsightSections(
                              color: AppColors.missedAttendenceColor,
                              icon: "assets/icons/Missed attendence.png",
                              count: "10",
                              label: AppConstants.missedAttendence,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                           Get.toNamed(AppRouter.APPROVAL_QUEUE_SCREEN);
                          },
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: Obx(
                              () => _buildQuickInsightSections(
                            color: AppColors.approvalQueueColor,
                            icon: "assets/icons/approval ques.png",
                            count: "${leaveController.leaveRequests.length}", // Will update automatically
                            label: AppConstants.approvalQueue,
                          ),
                        ),
                      ),
      ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                          Get.toNamed(AppRouter.NOTIFICATION_LIST_SCREEN);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Obx(() =>
                             _buildQuickInsightSections(
                                color: AppColors.blue,
                                icon: "assets/icons/recent updates.png",
                                count: "${adminMessageController.messages.length}",
                                label: AppConstants.recentUpdates,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppConstants.summary,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1.0, // 100% line height
                      letterSpacing: 0.0,
                      color: AppColors.textBlack.withValues(alpha: 80),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: buildSummary(
                          imagePath: "assets/icons/check in and checck out 2.png",
                          title: AppConstants.clockInOut,
                          onTap: () {
                            Get.toNamed(AppRouter.CHECK_IN_OUT_SCREEN);
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: buildSummary(
                          imagePath: "assets/icons/annual leave.png",
                          title: AppConstants.annualLeave,
                          onTap: () {
                           Get.toNamed(AppRouter.ANNUAL_LEAVE);
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: buildSummary(
                          imagePath: "assets/icons/apply leave.png",
                          title: AppConstants.applyLeave,
                          onTap: () {
                            Get.toNamed(AppRouter.LEAVE_SCREEN);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppConstants.leaveBalance,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1.0, // 100% line height
                      letterSpacing: 0.0,
                      color: AppColors.textBlack.withValues(alpha: 80),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          return buildLeaveBalance(
                            imagePath: "assets/icons/annual leave.png",
                            count: leaveController.annualLeaveCount.value,
                            title: AppConstants.annualLeave,
                            color: AppColors.annualLeaveColor,
                            onTap: () {
                              print("Annual Leave tapped");
                            },
                          );
                        }),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(() {
                          return buildLeaveBalance(
                            imagePath: "assets/icons/sick leave.png",
                            count: leaveController.sickLeaveCount.value,
                            title: AppConstants.sickLeave,
                            color: AppColors.sickLeaveColor,
                            onTap: () {
                              print("Sick Leave tapped");
                            },
                          );
                        }),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(() {
                          return buildLeaveBalance(
                            imagePath: "assets/icons/compensational leave.png",
                            count: leaveController.compensationalLeaveCount.value,
                            title: AppConstants.compensationalLeave,
                            color: AppColors.compLeaveColor,
                            onTap: () {
                              print("Compensational Leave tapped");
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          return buildLeaveBalance(
                            imagePath: "assets/icons/unpaid leave.png",
                            count: leaveController.unpaidLeaveCount.value,
                            title: AppConstants.unpaidLeave,
                            color: AppColors.unPaidLeaveColor,
                            onTap: () {
                              print("Unpaid Leave tapped");
                            },
                          );
                        }),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: buildDummyLeaveBalance()),
                      const SizedBox(width: 12),
                      Expanded(child: buildDummyLeaveBalance()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

Widget _buildQuickInsightSections({
  required Color color,
  required String icon,
  required String count,
  required String label,
}) {
  return Container(
    height: 136,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: color,
    ),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 26,
              width: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: AppColors.white,
              ),
              child: Image.asset(icon, height: 16, width: 16),
            ),
            Text(
              count,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                height: 1.0,
                letterSpacing: 0.0,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            height: 1.0,
            letterSpacing: 0.0,
            color: AppColors.white,
          ),
        ),
      ],
    ),
  );
}

Widget buildSummary({
  required String imagePath,
  required String title,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      width: 116,
      height: 136,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(color: AppColors.blue),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                height: 20,
                width: 20,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              height: 1.0,
              color: AppColors.textBlack.withAlpha(200),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget buildLeaveBalance({
  required String imagePath,
  required String count,
  required String title,
  required Color color,
  required VoidCallback onTap,
}) {
  return
 InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      width: 116,
      height: 136,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.textBlack.withOpacity(0.2)),
              color: AppColors.containerColor.withOpacity(0.05),
            ),
            child: Center(
              child: Image.asset(imagePath, height: 20, width: 20),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                count,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.0,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  height: 0.9,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildDummyLeaveBalance() {
  return Container(
    width: 116,
    height: 136,
    color: AppColors.backGroundColor.withAlpha(10),

  );
}













