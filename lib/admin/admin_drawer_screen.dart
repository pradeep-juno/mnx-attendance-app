import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mnx_attendance_app/app_utils/app_colors.dart'; // Assuming AppColors is defined here
import 'package:mnx_attendance_app/app_router/app_router.dart'; // Assuming AppRouter is defined here
import 'package:firebase_auth/firebase_auth.dart';
import '../app_controller/auth_controller.dart';
import '../app_screens/profile_screen/agent_profile_screen.dart'; // For logout functionality

Future<void> _performLogout() async {
  try {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(AppRouter.MAIN_NAVIGATION); // Go to main navigation screen
  } catch (e) {
    Get.snackbar(
      'Logout Failed',
      'Something went wrong. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
    );
  }
}


class AdminDrawer extends StatefulWidget {
  const AdminDrawer({Key? key}) : super(key: key);

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600; // Define a breakpoint for larger screens

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Drawer(
          width: isLargeScreen ? 300 : screenWidth * 0.75, // Adjust drawer width based on screen size
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column( // Use Column to place header and then scrollable list
            children: [
              // --- Drawer Header ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.backgroundWhite,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    ),
                    const SizedBox(height: 10),
                    buildTextFun(
                      context,
                      'HRM Admin',
                      fontSize: isLargeScreen ? 24 : 20, // Responsive font size
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    buildTextFun(
                      context,
                      'Administrator Access', // Subtitle for clarity
                      fontSize: isLargeScreen ? 14 : 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),

              // --- Drawer Items ---
              Expanded( // Ensures the ListView takes available space and is scrollable
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Notification
                    _buildDrawerItem(
                      icon: Icons.notifications,
                      title: "Notifications",
                      onTap: () {
                        Get.toNamed(AppRouter.ADMIN_NOTIFICATION_SCREEN);
                      },
                      isLargeScreen: isLargeScreen,
                    ),
                    // Leave Approval
                    _buildDrawerItem(
                      icon: Icons.approval,
                      title: "Leave Approval",
                      onTap: () {
                        Get.toNamed(AppRouter.ADMIN_LEAVE_APPROVAL_SCREEN);
                      },
                      isLargeScreen: isLargeScreen,
                    ),
                    // Add a Divider for visual separation before logout
                    const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Colors.grey),
                    // Logout
                    _buildDrawerItem(
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () {
                        // Show confirmation dialog before logging out
                        Get.defaultDialog(
                          title: "Confirm Logout",
                          middleText: "Are you sure you want to log out?",
                          textConfirm: "Logout",
                          textCancel: "Cancel",
                          confirmTextColor: Colors.white,
                          buttonColor: AppColors.primaryColor,
                          cancelTextColor: AppColors.primaryColor,
                          onConfirm: () async {
                            Get.back(); // Close the dialog
                            await _performLogout(); // Perform logout
                          },
                          onCancel: () {
                            // Do nothing, dialog closes
                          },
                        );
                      },
                      isLargeScreen: isLargeScreen,
                      isLogout: true, // Special styling for logout
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build consistent drawer items
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isLargeScreen,
    bool isLogout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.redAccent : AppColors.primaryColor,
          size: isLargeScreen ? 28 : 24, // Responsive icon size
        ),
        title: buildTextFun(
          context,
          title,
          style: GoogleFonts.roboto(
            fontSize: isLargeScreen ? 19 : 17, // Responsive font size
            fontWeight: FontWeight.w600,
            color: isLogout ? Colors.redAccent : Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: isLargeScreen ? 20 : 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hoverColor: AppColors.primaryColor.withOpacity(0.1),
        tileColor: isLogout ? Colors.red.shade50 : null, // Subtle background for logout
      ),
    );
  }
}