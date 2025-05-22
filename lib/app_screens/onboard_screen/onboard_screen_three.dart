import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_controller/onboard_controller.dart';
import '../../app_router/app_router.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/app_functions.dart';

class OnboardScreenThree extends StatefulWidget {
  const OnboardScreenThree({super.key});

  @override
  State<OnboardScreenThree> createState() => _OnboardScreenOneState();
}

class _OnboardScreenOneState extends State<OnboardScreenThree> {
  final OnBoardController onBoardController = Get.put(OnBoardController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      buildImageFun(
                        context,
                        AppConstants.onboardScreenImageThree,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Positioned(
                        top: 34,
                        left: 15,
                        child: buildContainerButtonFun(
                          context,
                          AppConstants.back,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.orange,
                          onPressed: () {
                            print('back button clicked!');
                            Get.offNamed(AppRouter.ONBOARD_SCREEN_TWO);
                          },
                          color: AppColors.backgroundWhite,
                          height: 40,
                          width: 90,
                        ),
                      ),
                    ],
                  ),
                  buildSizedBoxHeightFun(context, height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: buildTextFun(
                      context,
                      AppConstants.onBoardingScreenThreeDescriptionFirst,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  buildSizedBoxHeightFun(context, height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: buildTextFun(
                      context,
                      AppConstants.onBoardingScreenThreeDescriptionSecond,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: AppColors.grey,
                    ),
                  ),
                  buildSizedBoxHeightFun(context, height: 30),
                ],
              ),
            ),
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Center(
                child: buildContainerButtonFun(
                  context,
                  AppConstants.getStarted,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  onPressed: () {
                    print('Get Started button clicked!');
                    Get.offNamed(AppRouter.AGENT_MAIN_SCREEN);
                  },
                  color: AppColors.orange,
                  fontColor: AppColors.backgroundWhite,
                  height: 48,
                  width: 240,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
