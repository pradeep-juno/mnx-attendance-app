import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_router/app_router.dart';
import 'app_utils/app_colors.dart';
import 'app_utils/app_constants.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryBlue,
          onPrimary: AppColors.backgroundWhite,
          secondary: AppColors.primaryColor,
          onSecondary: AppColors.backgroundWhite,
        ),
        textTheme: GoogleFonts.nunitoTextTheme(), // Corrected line
        useMaterial3: true,
      ),
      title: AppConstants.hrmAttendance,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.SPLASH_SCREEN,
      getPages: AppRouter.routes,
    );
  }
}
