import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_controller/onboard_controller.dart';
import '../../app_router/app_router.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/app_functions.dart';

class OnboardScreenOne extends StatefulWidget {
  const OnboardScreenOne({super.key});

  @override
  State<OnboardScreenOne> createState() => _OnboardScreenOneState();
}

class _OnboardScreenOneState extends State<OnboardScreenOne> {
  final OnBoardController onBoardController = Get.put(OnBoardController());

  @override
  void initState() {
    super.initState();
    onBoardController.toggleButton();
  }

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
                        AppConstants.onboardScreenImaegeOne,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Positioned(
                        top: 34,
                        right: 15,
                        left: 240,
                        child: buildContainerButtonFun(
                          context,
                          AppConstants.skip,
                          fontSize: 14,
                          fontColor: AppColors.orange,
                          onPressed: () {
                            print('skip button clicked!');
                            Get.offNamed(AppRouter.ONBOARD_SCREEN_THREE);
                          },
                          fontWeight: FontWeight.w500,
                          showIcon: false,
                          color: AppColors.backgroundWhite,
                          height: 40,
                          width: 90,
                        ),
                      ),
                    ],
                  ),
                  buildSizedBoxHeightFun(context, height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: buildTextFun(
                      context,
                      AppConstants.onBoardingScreenOneDescriptionFirst,
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
                      AppConstants.onBoardingScreenOneDescriptionSecond,
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
                  AppConstants.next,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.orange,
                  onPressed: () {
                    print('next button clicked!');
                    Get.offNamed(AppRouter.ONBOARD_SCREEN_TWO);
                  },
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
