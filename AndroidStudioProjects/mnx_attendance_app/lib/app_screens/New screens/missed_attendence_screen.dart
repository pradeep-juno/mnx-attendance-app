import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_utils/app_colors.dart';
import '../../app_utils/app_constants.dart';


class MissedAttendanceScreen extends StatefulWidget {
  const MissedAttendanceScreen({super.key});

  @override
  State<MissedAttendanceScreen> createState() => _MissedAttendanceScreenState();
}

class _MissedAttendanceScreenState extends State<MissedAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor:AppColors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading:  InkWell(
          onTap: () {
            Get.back();
          },
          child: Image.asset(
            "assets/icons/back.png",
            height: 32,
            width: 32,
          ),
        ),

        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Missed Attendance',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            height: 1.0, // 100% line height
            letterSpacing: 0.32, // 2% of 16px
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack.withValues(alpha: 0.9),
          ),
        ),
      ),

      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          double screenWidth = MediaQuery.of(context).size.width;
          return Container(
            width: screenWidth * 0.9,
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(AppConstants.clockInTwo,
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          Text(AppConstants.clockOut,
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("09.30 AM",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  color: Color(0xFF00156A))),
                          Text("--/--/---",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  color: Color(0xFF00156A))),
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
                            child: Text(
                              "Vadapalani, Chennai",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
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
                    Row(
                      children: [
                        Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(width: 3),
                        Text(
                          "Missed",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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

                        ],
                      ),
                    ),
                    SizedBox(height: 6),

                    // Orange Indicators
                    Text(
                      AppConstants.details,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 4),

                    // Blue Dot Indicator (below orange)

                  ],
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
