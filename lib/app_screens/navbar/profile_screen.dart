import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../app_router/app_router.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/app_constants.dart';
import '../../../app_utils/app_functions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildTopLogoFun(context, AppConstants.hrmLogo),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Divider(),
                    buildSizedBoxHeightFun(context, height: 20),
                    buildIconTextFunction(
                      context,
                      image: AppConstants.myProfileIConImage,
                      text: AppConstants.myProfile,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.black,
                      onTap: () {
                        print("my profile clicked");
                         Get.toNamed(AppRouter.AGENT_PROFILE_SCREEN);
                      },
                    ),
                    const Divider(),
                    buildSizedBoxHeightFun(context, height: 20),
                    buildIconTextFunction(
                      context,
                      image: AppConstants.myProfileIConImage,
                      text: AppConstants.myProfile,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.black,
                      onTap: () {
                        print("my profile clicked");
                        Get.toNamed(AppRouter.LEAVE_APP);
                      },
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildIconTextFunction(
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
