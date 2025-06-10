import 'package:flutter/material.dart';
import 'package:mnx_attendance_app/app_screens/navbar/profile_screen.dart';

import '../../../storage_services/users_storage_service.dart';
import '../../admin/notification_screen.dart';
import 'attendance_screen.dart';
import 'dashboard_screen.dart';
import 'google_nav_bar.dart';
import 'leave_screen.dart';


class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      String userId = UsersStorageService.getUserId().toString();
      print("AGENT_MAIN_SCREEN : USER_ID => $userId");
    });
  }


  final List<Widget> _screens = [
    DashboardScreen(),
    AttendanceScreen(),
    LeaveScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: GNavBarWidget(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
