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
  final bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // The iconSize of GNav will now directly control the size of all GButton icons.
    // Adjusted slightly for a good visual fit with Material Icons.
    final double navIconSize = screenWidth * 0.065;

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
            rippleColor: Colors.white.withOpacity(0.15),
            hoverColor: Colors.white.withOpacity(0.1),
            haptic: true,
            tabBorderRadius: 12,
            curve: Curves.easeOutExpo,
            duration: const Duration(milliseconds: 400),
            gap: screenWidth * 0.015,
            color: Colors.white70, // Inactive icon color
            activeColor: Colors.white, // Active icon color
            iconSize: navIconSize, // GNav will apply this size to its icons
            tabBackgroundColor: Colors.white.withOpacity(0.12),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.012,
            ),
            tabs: [
              GButton(
                icon: Icons.home_filled, // Home icon
                text: 'Home',
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              GButton(
                icon: Icons.event_available , // Attendance/Check icon
                text: 'Attendance',
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              GButton(
                icon: Icons.work_off_outlined,
                text: 'Leave',
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              GButton(
                icon: Icons.person_outline, // Profile icon
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