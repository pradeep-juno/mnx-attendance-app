import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_controller/clockIn_ClockOut_Controller.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/app_constants.dart';

class ClockInScreen extends StatefulWidget {

  const ClockInScreen({super.key});

  @override
  State<ClockInScreen> createState() => _ClockInScreenState();
}

class _ClockInScreenState extends State<ClockInScreen> {
  final ClockInClockOutController controller = Get.find<ClockInClockOutController>();


  late final bool isClockIn;

  @override
  void initState() {
    super.initState();
    final actionType = Get.arguments['actionType'];
    isClockIn = actionType == 'clock-in';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          leading: IconButton(
            icon: Image.asset('assets/icons/back.png', height: 32, width: 32),
            onPressed: () => Get.back(),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/clock_in_screen_1.png', height: 21, width: 21),
              const SizedBox(width: 8),
              const Text(
                AppConstants.clockInClockOut,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          centerTitle: true,
          scrolledUnderElevation: 0,
        ),
        body: Obx(() {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.backGroundColor.withAlpha(50),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      isClockIn
                          ? AppConstants.clickToSubmitClockIN
                          : AppConstants.clickToSubmitClockOut,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Clock In/Out Button
                    GestureDetector(
                      onTap: () {
                        isClockIn
                            ? controller.clockInNow()
                            : controller.clockOutNow();
                      },
                      child: Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF001858),
                            ),
                            child: Center(
                              child: Text(
                                isClockIn
                                    ? (controller.clockInTime.value == null
                                    ? AppConstants.clockInTwo
                                    : controller.clockInTime.value!
                                    .toLocal()
                                    .toString()
                                    .substring(11, 16))
                                    : (controller.clockOutTime.value == null
                                    ? AppConstants.clockOutTwo
                                    : controller.clockOutTime.value!
                                    .toLocal()
                                    .toString()
                                    .substring(11, 16)),
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/location icon.png', width: 26, height: 26),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            controller.address.value,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Clock-In/Out Text Details
                    Row(
                      children: [
                        const Text(
                          AppConstants.clockIn,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColors.textBlack,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.clockInTime.value == null
                              ? "No Clock-In Recorded"
                              : controller.clockInTime.value!
                              .toLocal()
                              .toString()
                              .substring(0, 19),
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          AppConstants.clockOut,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColors.textBlack,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.clockOutTime.value == null
                              ? "No Clock-Out Recorded"
                              : controller.clockOutTime.value!
                              .toLocal()
                              .toString()
                              .substring(0, 19),
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    // Submit Button
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          isClockIn
                              ? controller.submitClockIn()
                              : controller.submitClockOut();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          AppConstants.submit,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
