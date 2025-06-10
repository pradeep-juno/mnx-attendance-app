import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_router/app_router.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/app_functions.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnAuthState();
  }

  Future<void> _navigateBasedOnAuthState() async {
    await Future.delayed(const Duration(seconds: 2));

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection(AppConstants.collectionAuth)
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        print("SplashScreen -> userId : ${user.uid}");
        Get.offNamed(AppRouter.AGENT_MAIN_SCREEN);
      } else {
        buildScaffoldErrorMessage(
            context, 'User record not found. Please contact support.');
      }
    } else {
      Get.offNamed(AppRouter.LOGIN_SCREEN);
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Image.asset(
            AppConstants.hrmLogo,
            height: 150,
            width: 150,
          ),
        ),
      ),
    );
  }
}
