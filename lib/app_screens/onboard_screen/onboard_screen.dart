import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../app_controller/onboard_controller.dart';
import '../../app_router/app_router.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/app_functions.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen>  {
  final OnBoardController onBoardController = Get.put(OnBoardController());

  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  final int totalPages = 3;

  @override
  void initState() {
    super.initState();
    onBoardController.toggleButton();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onNext() {
    if (currentIndex < totalPages - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut);
    } else {
      // Last page => Navigate to main screen
      Get.offNamed(AppRouter.AGENT_MAIN_SCREEN);
    }
  }

  void onSkip() {
    _pageController.jumpToPage(totalPages - 1);
  }


  void onBack() {
    if (currentIndex > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut);
    }
  }

  Widget buildPageContentWithoutIndicator(BuildContext context, int index) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Data per page
    late String imagePath;
    late String firstDesc;
    late String secondDesc;

    switch (index) {
      case 0:
        imagePath = AppConstants.onboardScreenImaegeOne;
        firstDesc = AppConstants.onBoardingScreenOneDescriptionFirst;
        secondDesc = AppConstants.onBoardingScreenOneDescriptionSecond;
        break;
      case 1:
        imagePath = AppConstants.onboardScreenImaegeTwo;
        firstDesc = AppConstants.onBoardingScreenTwoDescriptionFirst;
        secondDesc = AppConstants.onBoardingScreenTwoDescriptionSecond;
        break;
      case 2:
      default:
        imagePath = AppConstants.onboardScreenImageThree;
        firstDesc = AppConstants.onBoardingScreenThreeDescriptionFirst;
        secondDesc = AppConstants.onBoardingScreenThreeDescriptionSecond;
        break;
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                buildImageFun(
                  context,
                  imagePath,
                  width: screenWidth,
                ),
                Positioned(
                  top: screenHeight * 0.04,
                  left: screenWidth * 0.04,
                  right: screenWidth * 0.04,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (index != 0)
                        buildContainerButtonFun(
                          context,
                          AppConstants.back,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.backgroundWhite,
                          onPressed: onBack,
                          fontColor: AppColors.primaryColor,
                          height: 40,
                          width: 90,
                        )
                      else
                        const SizedBox(width: 90), // Empty space to align "Skip" properly

                      if (index != 2)
                        buildContainerButtonFun(
                          context,
                          AppConstants.skip,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.primaryColor,
                          onPressed: onSkip,
                          color: AppColors.backgroundWhite,
                          height: 40,
                          width: 90,
                        )
                      else
                        const SizedBox(width: 90), // Empty space to align "Back" properly
                    ],
                  ),
                ),

              ],
            ),
            buildSizedBoxHeightFun(context, height: screenHeight * 0.015),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
              child: buildTextFun(
                context,
                firstDesc,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            buildSizedBoxHeightFun(context, height: screenHeight * 0.015),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
              child: buildTextFun(
                context,
                secondDesc,
                fontSize: 14,
                fontWeight: index == 1 ? FontWeight.w500 : FontWeight.w300,
                color: AppColors.grey,
              ),
            ),
            SizedBox(height: screenHeight * 0.2),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: totalPages,
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return buildPageContentWithoutIndicator(context, index);
            },
          ),

          // Fixed Bottom Indicator and Button
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IgnorePointer(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: totalPages,
                    effect: ExpandingDotsEffect(
                      expansionFactor: 3,
                      dotHeight: 12,
                      dotWidth: 12,
                      activeDotColor: AppColors.primaryColor,
                      dotColor: AppColors.grey.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: buildContainerButtonFun(
                    context,
                    currentIndex == totalPages - 1
                        ? AppConstants.getStarted
                        : AppConstants.next,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    onPressed: onNext,
                    color: AppColors.primaryColor,
                    fontColor: AppColors.backgroundWhite,
                    height: 48,
                    width: screenWidth * 0.85,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
