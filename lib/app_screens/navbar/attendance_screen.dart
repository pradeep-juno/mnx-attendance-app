import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../app_utils/app_colors.dart';
import '../../app_utils/app_constants.dart';


class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {

  int touchedIndex = -1;

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
                                Image.asset("assets/icons/calender.png", height: 14, width: 14),
                                Text(
                                  "21-apr-2025",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    height: 1.0,
                                    letterSpacing: 0.0,
                                    color: AppColors.blue,
                                  ),
                                ),
                                Image.asset("assets/icons/Drop Down.png", height: 21, width: 21),
                              ],
                            ),
                          ),
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
                                Image.asset("assets/icons/calender.png", height: 14, width: 14),
                                Text(
                                  "27-apr-2025",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    height: 1.0,
                                    letterSpacing: 0.0,
                                    color: AppColors.blue,
                                  ),
                                ),
                                Image.asset("assets/icons/Drop Down.png", height: 21, width: 21),
                              ],
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
                                  swapAnimationDuration: const Duration(milliseconds: 100),
                                  swapAnimationCurve: Curves.easeInOut,
                                )
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "21 - Apr -2025",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  AppConstants.present,
                                  style: TextStyle(
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
                        children: [
                          legendItem(Color(0xFF4CAF50), "Present"),
                          legendItem(Color(0xFFFF9800), "Late Arrival"),
                          legendItem(Color(0xFFFFC107), "Early Departure"),
                          legendItem(Color(0xFF2196F3), "Over Time"),
                          legendItem(Color(0xFF80CBC4), "Holiday"),
                          legendItem(Color(0xFF3F51B5), "Holiday Working"),
                          legendItem(Color(0xFF673AB7), "Leave"),
                          legendItem(Color(0xFFF44336), "Absent"),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// >>>>> LISTVIEW BUILDER <<<<<

                    ],
                  ),
                ),
              ),
              // SizedBox(height: 32,),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child: SizedBox(
              //     height: 200,  // Adjust height as needed
              //     child: /// >>>>> LISTVIEW BUILDER <<<<<
              //     SizedBox(
              //       height: 400, // Adjust height based on content or make it flexible
              //       child: ListView.builder(
              //         itemCount: 5,
              //         itemBuilder: (context, index) {
              //           double screenWidth = MediaQuery.of(context).size.width;
              //           return Container(
              //             width: screenWidth * 0.9,
              //             margin: EdgeInsets.only(bottom: 16),
              //             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              //             decoration: BoxDecoration(
              //               color: Colors.white,
              //               borderRadius: BorderRadius.circular(12),
              //               boxShadow: [
              //                 BoxShadow(
              //                   color: Colors.black.withOpacity(0.05),
              //                   offset: Offset(0, 4),
              //                   blurRadius: 6,
              //                 ),
              //               ],
              //             ),
              //             child: Row(
              //               children: [
              //                 // Left Date Container
              //                 Container(
              //                   width: 65,
              //                   height: 64,
              //                   decoration: BoxDecoration(
              //                     color: Color(0xFF00156A),
              //                     borderRadius: BorderRadius.circular(10),
              //                   ),
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       Text(
              //                         "14",
              //                         style: TextStyle(
              //                           fontFamily: 'Montserrat',
              //                           fontWeight: FontWeight.bold,
              //                           fontSize: 18,
              //                           color: Colors.white,
              //                         ),
              //                       ),
              //                       Text(
              //                         "Jan",
              //                         style: TextStyle(
              //                           fontFamily: 'Montserrat',
              //                           fontWeight: FontWeight.w400,
              //                           fontSize: 12,
              //                           color: Colors.white,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //
              //                 SizedBox(width: 12),
              //
              //                 // Clock In/Out + Location
              //                 Expanded(
              //                   child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Row(
              //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                         children: [
              //                           Text(AppConstants.clockIn,
              //                               style: TextStyle(
              //                                   fontFamily: 'Montserrat',
              //                                   fontSize: 14,
              //                                   fontWeight: FontWeight.w600,
              //                                   color: Colors.black)),
              //                           Text(AppConstants.clockOut,
              //                               style: TextStyle(
              //                                   fontFamily: 'Montserrat',
              //                                   fontSize: 14,
              //                                   fontWeight: FontWeight.w600,
              //                                   color: Colors.black)),
              //                         ],
              //                       ),
              //                       SizedBox(height: 4),
              //                       Row(
              //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                         children: [
              //                           Text("09.30 AM",
              //                               style: TextStyle(
              //                                   fontFamily: 'Montserrat',
              //                                   fontSize: 14,
              //                                   color: Color(0xFF00156A))),
              //                           Text("05.30 PM",
              //                               style: TextStyle(
              //                                   fontFamily: 'Montserrat',
              //                                   fontSize: 14,
              //                                   color: Color(0xFF00156A))),
              //                         ],
              //                       ),
              //                       SizedBox(height: 4),
              //                       Row(
              //
              //                         children: [
              //                           Image.asset(
              //                             "assets/icons/location icon.png",
              //                             height: 18,
              //                             width: 18,
              //                           ),
              //                           SizedBox(width: 4),
              //                           Expanded(
              //                             child: Text(
              //                               "Vadapalani, Chennai",
              //                               style: TextStyle(
              //                                 fontFamily: 'Montserrat',
              //                                 fontSize: 14,
              //                                 color: Colors.grey[600],
              //                               ),
              //                               overflow: TextOverflow.ellipsis,
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //
              //                 // Eye icon and indicators
              //                 Column(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     GestureDetector(
              //                       onTap: () {
              //                         print("Details tapped");
              //                       },
              //                       child: Column(
              //                         children: [
              //                           Image.asset(
              //                             "assets/icons/eye.png",
              //                             height: 22,
              //                             width: 22,
              //                           ),
              //                           SizedBox(height: 4),
              //                           Text(
              //                             AppConstants.details,
              //                             style: TextStyle(
              //                               fontFamily: 'Montserrat',
              //                               fontSize: 10,
              //                               color: Colors.blue,
              //                               fontWeight: FontWeight.w600,
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                     SizedBox(height: 6),
              //
              //                     // Orange Indicators
              //                     Row(
              //                       children: [
              //                         Container(
              //                           height: 8,
              //                           width: 8,
              //                           margin: EdgeInsets.only(right: 4),
              //                           decoration: BoxDecoration(
              //                             color: Color(0xFFFF9800),
              //                             borderRadius: BorderRadius.circular(2),
              //                           ),
              //                         ),
              //                         Container(
              //                           height: 8,
              //                           width: 8,
              //                           decoration: BoxDecoration(
              //                             color: Color(0xFFFFC107),
              //                             borderRadius: BorderRadius.circular(2),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //
              //                     SizedBox(height: 4),
              //
              //                     // Blue Dot Indicator (below orange)
              //                     Container(
              //                       height: 8,
              //                       width: 8,
              //                       decoration: BoxDecoration(
              //                         color: Color(0xFF2196F3),
              //                         borderRadius: BorderRadius.circular(2),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           );
              //         },
              //       ),
              //
              //     ),
              //
              //
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }


  /// PIE Chart sections
  List<PieChartSectionData> showingSections() {
    final List<Color> colors = [
      Color(0xFFF44336),
      Color(0xFF673AB7),
      Color(0xFF80CBC4),
      Color(0xFF2196F3),
      Color(0xFFFFC107),
      Color(0xFFFF9800),
      Color(0xFF4CAF50),
      Color(0xFF3F51B5),
    ];

    final List<double> values = [10, 20, 40, 70, 20, 20, 10, 10];

    return List.generate(values.length, (i) {
      final isTouched = i == touchedIndex;
      final double radius = isTouched ? 50 : 40;

      return PieChartSectionData(
        color: colors[i],
        value: values[i],
        title: '',
        radius: radius,
      );
    });
  }


  /// Legend widget
  Widget legendItem(Color color, String text) {
    return SizedBox(
      width: 130, // Fixed width to make everything aligned nicely
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
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
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




