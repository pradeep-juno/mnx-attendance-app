import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_controller/onboard_controller.dart';
import '../../app_router/app_router.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/app_functions.dart';

class OnboardScreenTwo extends StatefulWidget {
  const OnboardScreenTwo({super.key});

  @override
  State<OnboardScreenTwo> createState() => _OnboardScreenOneState();
}

class _OnboardScreenOneState extends State<OnboardScreenTwo> {
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
                        AppConstants.onboardScreenImaegeTwo,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 34, left: 10),
                            child: buildContainerButtonFun(
                              context,
                              AppConstants.back,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.backgroundWhite,
                              onPressed: () {
                                print('back button clicked!');
                                Get.offNamed(AppRouter.ONBOARD_SCREEN_ONE);
                              },
                              fontColor: AppColors.orange,
                              height: 40,
                              width: 90,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 34, right: 10),
                            child: buildContainerButtonFun(
                              context,
                              AppConstants.skip,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.orange,
                              onPressed: () {
                                print('skip button clicked!');
                                Get.offNamed(AppRouter.ONBOARD_SCREEN_THREE);
                              },
                              color: AppColors.backgroundWhite,
                              height: 40,
                              width: 90,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  buildSizedBoxHeightFun(context, height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: buildTextFun(
                      context,
                      AppConstants.onBoardingScreenTwoDescriptionFirst,
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
                      AppConstants.onBoardingScreenTwoDescriptionSecond,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey,
                    ),
                  ),
                  buildSizedBoxHeightFun(context, height: 70),
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
                    Get.offNamed(AppRouter.ONBOARD_SCREEN_THREE);
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
