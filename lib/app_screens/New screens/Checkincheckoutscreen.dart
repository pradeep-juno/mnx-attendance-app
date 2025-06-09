import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app_controller/clockIn_ClockOut_Controller.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/app_constants.dart';


class Checkincheckoutscreen extends StatefulWidget {
  const Checkincheckoutscreen({super.key});

  @override
  State<Checkincheckoutscreen> createState() => _CheckincheckoutscreenState();
}

class _CheckincheckoutscreenState extends State<Checkincheckoutscreen> {
  final ClockInClockOutController clockInClockOutcontroller = Get.put(
    ClockInClockOutController(),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
            'Check In & Check Out',
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
        body: Container(
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 41,
                      width: 142,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: AppColors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            "assets/icons/calender.png",
                            height: 14,
                            width: 14,
                          ),
                          Text(
                            "Month",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              height: 1.0,
                              letterSpacing: 0.0,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Image.asset(
                            "assets/icons/Drop Down.png",
                            height: 21,
                            width: 21,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 30),
                    Container(
                      height: 41,
                      width: 142,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: AppColors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            "assets/icons/calender.png",
                            height: 14,
                            width: 14,
                          ),
                          Text(
                            "Year",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              height: 1.0,
                              letterSpacing: 0.0,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Image.asset(
                            "assets/icons/Drop Down.png",
                            height: 21,
                            width: 21,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15),

                Expanded(
                  child: ListView.builder(
                      itemCount: 10,
                    itemBuilder: (context, index) {
                      double screenWidth = MediaQuery.of(context).size.width;
                      return Container(
                        width: screenWidth * 0.9,
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: Offset(0, 4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Left Date Container
                            Container(
                              width: 65,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Color(0xFF00156A),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "14",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Jan",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 12),

                            // Clock In/Out + Location
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        AppConstants.clockIn,
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        AppConstants.clockOut,
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Obx(() {
                                        final time =
                                            clockInClockOutcontroller
                                                .clockInTime
                                                .value;

                                        final formattedTime =
                                            time != null
                                                ? DateFormat(
                                                  'hh:mm a',
                                                ).format(time)
                                                : "Not In";

                                        return Text(
                                          formattedTime,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 14,
                                            // Match the previous size
                                            color: Color(
                                              0xFF00156A,
                                            ), // Match the previous color
                                          ),
                                        );
                                      }),

                                      Obx(() {
                                        final time =
                                            clockInClockOutcontroller
                                                .clockInTime
                                                .value;

                                        final formattedTime =
                                        time != null
                                            ? DateFormat(
                                          'hh:mm a',
                                        ).format(time)
                                            : "Not In";

                                        return Text(
                                          formattedTime,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 14,
                                            // Match the previous size
                                            color: Color(
                                              0xFF00156A,
                                            ), // Match the previous color
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/icons/location icon.png",
                                        height: 18,
                                        width: 18,
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Obx(() {
                                          return Text(
                                            clockInClockOutcontroller
                                                .address
                                                .value,
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Eye icon and indicators
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print("Details tapped");
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/icons/eye.png",
                                        height: 22,
                                        width: 22,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        AppConstants.details,
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 6),

                                // Orange Indicators
                                Row(
                                  children: [
                                    Container(
                                      height: 8,
                                      width: 8,
                                      margin: EdgeInsets.only(right: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    Container(
                                      height: 8,
                                      width: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.amberAccent,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
