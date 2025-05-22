import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_controller/auth_controller.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/app_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            ListView(
              children: [
                const WaveHeader(), // Top wave header

                const SizedBox(height: 20),

                // Login Header (already includes logo inside)
                buildAuthHeaderFun(context, AppConstants.loginCaps),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: authController.authKey,
                    child: Column(
                      children: [
                        buildLoginBodyFun(context, authController),
                        const SizedBox(height: 20),
                        buildLoginButtonFun(context, authController),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Loading overlay
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
