import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mnx_attendance_app/app_router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_controller/auth_controller.dart';
import '../../app_controller/user_profile_controller.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/app_functions.dart';



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
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  userProfileController.updateUserProfile(
                    name: nameController.text.trim(),
                    mobileNumber: mobileController.text.trim(),
                  );
                  Navigator.pop(context); // Close bottom sheet
                },
                child: const Text('Save Changes'),
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
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                buildProfileHeaderFun(
                context,
                AppConstants.edit,
                isTitleClickable: true,
                onTitleTap: () {
                  print("Title clicked!");
                  showEditProfileBottomSheet(context);
                  // Do something here
                },
              ),

                buildSizedBoxHeightFun(context, height: 12),
                  buildUserProfile(
                      context, userProfileController, authController),
                  buildSizedBoxHeightFun(context,
                      height:
                      24), // Optional spacing at the bottom to prevent cutoff
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
}


buildUserProfile(
    BuildContext context,
    UserProfileController userProfileController,
    AuthController authController) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildIconTextFunction(
            context,
            image: AppConstants.myProfileIConImage,
            text: AppConstants.myProfile,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            textColor: AppColors.black,
            onTap: () {},
          ),
          buildSizedBoxHeightFun(context, height: 16),
          buildTitleSubtitleWithColumn(context,
              title: AppConstants.name,
              subTitle: userProfileController.authName),
          buildSizedBoxHeightFun(context, height: 16),
          buildTitleSubtitleWithColumn(context,
              title: AppConstants.emailAddress,
              subTitle: userProfileController.authEmailAddress),
          buildSizedBoxHeightFun(context, height: 16),
          buildTitleSubtitleWithColumn(context,
              title: AppConstants.mobileNumber,
              subTitle: userProfileController.authMobileNumber),
          buildSizedBoxHeightFun(context, height: 16),
          buildTitleSubtitleWithColumn(context,
              title: AppConstants.position,
              subTitle: userProfileController.authPosition),
          buildSizedBoxHeightFun(context, height: 40),

          //change password

          buildIconTextFunction(
            context,
            image: AppConstants.changePasswordIconImage,
            text: AppConstants.changePassword,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            textColor: AppColors.black,
            onTap: () {
              Get.toNamed(AppRouter.AGENT_CHANGE_PASSWORD_SCREEN);
            },
          ),

          buildSizedBoxHeightFun(context, height: 16),

          //delete account
          buildIconTextFunction(
            context,
            image: AppConstants.deleteIconImage,
            text: AppConstants.deleteAccount,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            textColor: AppColors.black,
            onTap: () {
              authController.deleteAccount(context);
                Get.find<AuthController>().deleteAccount(context);
            },
          ),

          buildSizedBoxHeightFun(context, height: 16),

          //logout

          buildIconTextFunction(
            context,
            image: AppConstants.logoutIconImage,
            text: AppConstants.logout,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            textColor: AppColors.black,
            onTap: () {
              print("logout pressed");
              Get.defaultDialog(
                title: AppConstants.logoutConfirmation,
                middleText:
                AppConstants.areYouSureYouWantToLogout,
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

buildTitleSubtitleWithColumn(BuildContext context,
    {required String title, required RxString subTitle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildTextFun(context, title,
          fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black),
      buildSizedBoxHeightFun(context, height: 12),
      Obx(() {
        return buildTextFun(context, subTitle.value,
            fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.grey);
      })
    ],
  );
}

Widget  buildIconTextFunction(
    BuildContext context, {
      required String image,
      required String text,
      required double fontSize,
      required FontWeight fontWeight,
      required Color textColor,
      VoidCallback? onTap,
    }) {
  return InkWell(
    onTap: onTap,
    child: Row(
      children: [
        buildImageFun(context, image),
        buildSizedBoxWidthFun(context, width: 10),
        buildTextFun(
          context,
          text,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
        ),
      ],
    ),
  );
}


Future<void> logout(BuildContext context, AuthController authController) async {
  try {
    await FirebaseAuth.instance.signOut();
    print(AppConstants.logoutSuccessFully);


    // 🧹 Optional: Clear SharedPreferences if you store user data there
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // ✅ Show success message
    buildScaffoldSuccessMessage(context, AppConstants.logoutSuccessFully);

    // 🔄 Go to login screen
    Get.offAllNamed(AppRouter.LOGIN_SCREEN);
  } catch (e) {
    print('Error during logout: $e');
  } finally {
    authController.isLoading.value = false;
  }
}

