import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_controller/auth_controller.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/app_functions.dart';

class AgentChangePasswordScreen extends StatefulWidget {
  const AgentChangePasswordScreen({super.key});

  @override
  State<AgentChangePasswordScreen> createState() =>
      _AgentChangePasswordScreenState();
}

class _AgentChangePasswordScreenState extends State<AgentChangePasswordScreen> {
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    authController.authOldPasswordController.clear();
    authController.authNewPasswordController.clear();
    authController.authConfirmNewPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
                child: Column(
              children: [
                // Header remains fixed
                buildProfileHeaderFun(
                  context,
                  AppConstants.changePassword,
                ),
                // The scrollable content starts here
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildSizedBoxHeightFun(context, height: 20),
                        buildAgentChangePasswordBodyFun(
                          context,
                          authController,
                        ),
                        buildSizedBoxHeightFun(context, height: 40),
                        buildAgentChangePasswordButtonFun(
                          context,
                          authController,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
            Obx(() {
              if (authController.isLoading.value) {
                return loadingProgress(context); // Show loading indicator
              }
              return const SizedBox.shrink();
            })
          ],
        ),
      ),
    );
  }
}
