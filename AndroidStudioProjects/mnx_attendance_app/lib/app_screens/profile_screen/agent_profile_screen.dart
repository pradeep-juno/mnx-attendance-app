import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mnx_attendance_app/app_router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_controller/auth_controller.dart';
import '../../app_controller/user_profile_controller.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/app_constants.dart';


class AgentProfileScreen extends StatefulWidget {
  const AgentProfileScreen({super.key});

  @override
  State<AgentProfileScreen> createState() => _AgentProfileScreenState();
}

class _AgentProfileScreenState extends State<AgentProfileScreen> {
  final AuthController authController = Get.put(AuthController());
  final UserProfileController userProfileController =
  Get.put(UserProfileController());

  void showEditProfileBottomSheet(BuildContext context) {
    final nameController = TextEditingController(
      text: userProfileController.authName.value,
    );
    final mobileController = TextEditingController(
      text: userProfileController.authMobileNumber.value,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              TextField(
                controller: mobileController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    userProfileController.updateUserProfile(
                      name: nameController.text.trim(),
                      mobileNumber: mobileController.text.trim(),
                    );
                    Navigator.pop(context); // Close bottom sheet
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor, // Use your primary color
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    userProfileController.listenToUserProfileDataUpdates();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  buildProfileHeader(context, screenHeight, screenWidth),
                  SizedBox(height: screenHeight * 0.02),
                  buildProfileDetailsCard(context, userProfileController),
                  SizedBox(height: screenHeight * 0.03),
                  buildActionButtonsCard(context, authController),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
            Obx(() {
              return authController.isLoading.value
                  ? loadingProgress(context)
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  // --- Widget Builders for better organization and readability ---

  Widget buildProfileHeader(
      BuildContext context, double screenHeight, double screenWidth) {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.25,
      decoration: const BoxDecoration( // Changed to const as gradient is now const
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.lightPrimaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          // Back Button (New addition)
          Positioned(
            top: 16,
            left: 16, // Positioned on the left
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: screenWidth * 0.06),
              onPressed: () {
                Get.back(); // Use Get.back() to navigate back
              },
            ),
          ),
          // Edit Button (Existing)
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Icon(Icons.edit, color: Colors.white, size: screenWidth * 0.06),
              onPressed: () => showEditProfileBottomSheet(context),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.12,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: screenWidth * 0.15,
                    color: AppColors.primaryColor,
                  ), // Placeholder for user image
                ),
                SizedBox(height: screenHeight * 0.015),
                Obx(
                      () => Text(
                    userProfileController.authName.value,
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Obx(
                      () => Text(
                    userProfileController.authEmailAddress.value,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      // Fixed: Changed withValues to withOpacity
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileDetailsCard(
      BuildContext context, UserProfileController userProfileController) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildProfileDetailRow(
              context,
              icon: Icons.person_outline,
              title: AppConstants.name,
              subtitle: userProfileController.authName,
            ),
            buildDivider(),
            buildProfileDetailRow(
              context,
              icon: Icons.email_outlined,
              title: AppConstants.emailAddress,
              subtitle: userProfileController.authEmailAddress,
            ),
            buildDivider(),
            buildProfileDetailRow(
              context,
              icon: Icons.phone_outlined,
              title: AppConstants.mobileNumber,
              subtitle: userProfileController.authMobileNumber,
            ),
            buildDivider(),
            buildProfileDetailRow(
              context,
              icon: Icons.work_outline,
              title: AppConstants.position,
              subtitle: userProfileController.authPosition,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileDetailRow(BuildContext context,
      {required IconData icon,
        required String title,
        required RxString subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon remains the same, providing visual context
          Icon(icon, color: AppColors.primaryColor, size: 24),
          SizedBox(width: MediaQuery.of(context).size.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title: Bold and slightly larger
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15, // Slightly increased font size for title
                    fontWeight: FontWeight.bold, // Made title bold
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                // Subtitle: Semi-bold and clear
                Obx(
                      () => Text(
                    subtitle.value,
                    style: TextStyle(
                      fontSize: 16, // Increased font size for subtitle
                      fontWeight: FontWeight.w600, // Semi-bold for subtitle
                      color: AppColors.darkGrey, // Using a slightly darker grey for better readability, or keep AppColors.grey
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(color: AppColors.lightGrey, thickness: 1),
    );
  }

  Widget buildActionButtonsCard(
      BuildContext context, AuthController authController) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            buildActionListTile(
              context,
              icon: Icons.lock_outline,
              text: AppConstants.changePassword,
              onTap: () {
                Get.toNamed(AppRouter.AGENT_CHANGE_PASSWORD_SCREEN);
              },
            ),
            buildDivider(),
            buildActionListTile(
              context,
              icon: Icons.delete_outline,
              text: AppConstants.deleteAccount,
              textColor: AppColors.primaryColor, // Highlight delete with red
              onTap: () {
                Get.defaultDialog(
                  title: 'Delete Account',
                  middleText: 'Are you sure you want to delete your account? This action cannot be undone.',
                  textConfirm: 'Delete',
                  textCancel: 'Cancel',
                  confirmTextColor: Colors.white,
                  buttonColor: AppColors.primaryColor,
                  onConfirm: () {
                    Get.back(); // Close dialog
                    authController.deleteAccount(context);
                  },
                );
              },
            ),
            buildDivider(),
            buildActionListTile(
              context,
              icon: Icons.logout,
              text: AppConstants.logout,
              textColor: AppColors.primaryColor, // A slightly different color for logout
              onTap: () {
                Get.defaultDialog(
                  title: AppConstants.logoutConfirmation,
                  middleText: AppConstants.areYouSureYouWantToLogout,
                  textConfirm: AppConstants.yes,
                  textCancel: AppConstants.cancel,
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    Get.back(); // Close the dialog first
                    authController.isLoading.value =
                    true; // Show the loading indicator immediately
                    logout(context,
                        authController); // Proceed with the logout
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActionListTile(BuildContext context,
      {required IconData icon,
        required String text,
        Color textColor = AppColors.black,
        VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor, size: 28),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.grey),
      onTap: onTap,
    );
  }


  Future<void> logout(BuildContext context, AuthController authController) async {
    try {
      await FirebaseAuth.instance.signOut();
      print(AppConstants.logoutSuccessFully);

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      buildScaffoldSuccessMessage(context, AppConstants.logoutSuccessFully);

      Get.offAllNamed(AppRouter.LOGIN_SCREEN);
    } catch (e) {
      print('Error during logout: $e');
      // Optionally show an error message
      buildScaffoldErrorMessage(context, 'Logout failed: $e');
    } finally {
      authController.isLoading.value = false;
    }
  }
}


void buildScaffoldSuccessMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.green),
  );
}

void buildScaffoldErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.red),
  );
}


Widget loadingProgress(BuildContext context) {
  return Container(
    color: Colors.black.withValues(alpha: 0.5),
    child: const Center(
      child: CircularProgressIndicator(color: AppColors.primaryColor),
    ),
  );
}


Widget buildTextFun(BuildContext context, String text,
    {double? fontSize, FontWeight? fontWeight, Color? color, TextStyle? style}) {
  return Text(
    text,
    style: style ??
        GoogleFonts.montserrat(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
  );
}


Widget buildImageFun(BuildContext context, String imagePath,
    {double? height, double? width, BoxFit? fit}) {
  return Image.asset(
    imagePath,
    height: height,
    width: width,
    fit: fit,
  );
}


