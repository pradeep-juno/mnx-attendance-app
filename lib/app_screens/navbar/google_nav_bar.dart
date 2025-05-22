 import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class GNavBarWidget extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const GNavBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  State<GNavBarWidget> createState() => _GNavBarWidgetState();
}

class _GNavBarWidgetState extends State<GNavBarWidget> {
  bool _isVisible = true;

  void _handleSwipe(DragUpdateDetails details) {
    if (details.delta.dy > 0) {
      setState(() => _isVisible = false);
    } else if (details.delta.dy < 0) {
      setState(() => _isVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(


      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _isVisible ? screenHeight * 0.08 : 0,
        color: const Color(0xFF00126A),
        child: _isVisible
            ? Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02,
            vertical: screenHeight * 0.01,
          ),
          child: GNav(
            selectedIndex: widget.selectedIndex,
            onTabChange: widget.onTabChange,
            rippleColor: Colors.white.withOpacity(0.1),
            hoverColor: Colors.white.withOpacity(0.05),
            haptic: true,
            tabBorderRadius: 12,
            curve: Curves.easeOutExpo,
            duration: const Duration(milliseconds: 400),
            gap: 6,
            color: Colors.white70,
            activeColor: Colors.white,
            iconSize: screenWidth * 0.06,
            tabBackgroundColor: Colors.white.withOpacity(0.1),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.01,
            ),
            tabs: [
              GButton(
                icon: Icons.home,
                iconColor: Colors.transparent,
                leading: Image.asset(
                  'assets/icons/home.png',
                  height: screenHeight * 0.035,
                  width: screenHeight * 0.035,
                  fit: BoxFit.contain,
                ),
                text: 'Home',
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              GButton(
                icon: Icons.check,
                iconColor: Colors.transparent,
                leading: Image.asset(
                  'assets/icons/attendance.png',
                  height: screenHeight * 0.035,
                  width: screenHeight * 0.035,
                  fit: BoxFit.contain,
                ),
                text: 'Attendance',
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              GButton(
                icon: Icons.exit_to_app,
                iconColor: Colors.transparent,
                leading: Image.asset(
                  'assets/icons/leave.png',
                  height: screenHeight * 0.035,
                  width: screenHeight * 0.035,
                  fit: BoxFit.contain,
                ),
                text: 'Leave',
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              GButton(
                icon: Icons.person,
                iconColor: Colors.transparent,
                leading: Image.asset(
                  'assets/icons/profile.png',
                  height: screenHeight * 0.04,
                  width: screenHeight * 0.04,
                  fit: BoxFit.contain,
                ),
                text: 'Profile',
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
            : const SizedBox.shrink(),
      ),
    );
  }
}
