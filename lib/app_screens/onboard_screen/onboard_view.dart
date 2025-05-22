import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_controller/onboard_controller.dart';
import 'onboard_screen_one.dart';
import 'onboard_screen_three.dart';
import 'onboard_screen_two.dart';

class OnboardView extends StatefulWidget {
  const OnboardView({super.key});

  @override
  State<OnboardView> createState() => _OnboardViewState();
}

class _OnboardViewState extends State<OnboardView> {
  final OnBoardController onBoardController = Get.put(OnBoardController());
  int currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    final onboardScreens = [
      const OnboardScreenOne(),
      const OnboardScreenTwo(),
      const OnboardScreenThree()
    ];

    return SafeArea(
        child: Scaffold(
      body: PageView.builder(
        onPageChanged: (index) {
          setState(() {
            currentScreen = index;
          });
        },
        itemCount: onboardScreens.length,
        itemBuilder: (context, index) => onboardScreens[index],
      ),
    ));
  }
}
