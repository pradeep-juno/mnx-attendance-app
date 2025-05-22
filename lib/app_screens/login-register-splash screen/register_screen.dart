import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_controller/auth_controller.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/app_functions.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
              bottom: 120,
              child: buildCustomScrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildSizedBoxHeightFun(context, height: 30),
                      buildAuthHeaderFun(context, AppConstants.registerCaps),
                      buildSizedBoxHeightFun(context, height: 30),
                      buildRegisterBodyFun(context, authController),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 60,
              right: 60,
              child: buildRegisterButtonFun(context, authController),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Obx(() {
                return authController.isLoading.value
                    ? loadingProgress(context)
                    : const SizedBox.shrink();
              }),
            )
          ],
        ),
      ),
    );
  }
}
