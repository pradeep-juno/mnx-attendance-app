import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../app_controller/auth_controller.dart';
import '../app_router/app_router.dart';
import 'app_colors.dart';
import 'app_constants.dart';

buildVaadagaiLogo(BuildContext context, String image,
    {required double height, required double width}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Image.asset(
      image,
      height: height,
      width: width,
    ),
  );
}

buildSizedBoxHeightFun(BuildContext context, {required double height}) {
  return SizedBox(height: height);
}

buildSizedBoxWidthFun(BuildContext context, {required double width}) {
  return SizedBox(
    width: width,
  );
}


Widget  buildImageFun(BuildContext context, String image,
    {double? height, double? width, Color? color}) {
  return FutureBuilder(
    future: precacheImage(AssetImage(image), context),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Image.asset(
          image,
          height: height,
          width: width,
          fit: BoxFit.fitWidth,
          color: color,
        );
      } else if (snapshot.hasError) {
        return Icon(
          Icons.error,
          color: Colors.red,
          size: 40,
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}

buildTextFun(
  BuildContext context,
  String text, {
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
  bool buttonpress = false, // Default is false, meaning normal text
  VoidCallback? onTap,
  VoidCallback? onIconTap,
  Icon? prefixIcon,
  Color? circleColor,
  bool largetext = false,
  // Optional callback for the tap action
}) {
  return InkWell(
    onTap:
        buttonpress ? onTap : null, // Apply onTap only if buttonpress is true
    child: Row(
      mainAxisSize: MainAxisSize.min, // Fit the content
      children: [
        if (prefixIcon != null) // Only show the icon if it's provided
          InkWell(
            onTap: onIconTap,
            child: Padding(
              padding: const EdgeInsets.only(right: 10), // Add some spacing
              child: prefixIcon,
            ),
          ),
        Flexible(
          child: Text(
            text,
            textAlign: largetext ? TextAlign.center : TextAlign.start,
              style: GoogleFonts.montserrat(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: color,
              )
          ),
        ),
      ],
    ),
  );
}

Widget buildContainerButtonFun(
  BuildContext context,
  String text, {
  required int fontSize,
  required FontWeight fontWeight,
  Color? color,
  Function()? onPressed,
  required double height,
  required double width,
  Color? fontColor = Colors.white,
  bool circle = false,
  Color? circleColor = Colors.black,
  bool showIcon = false,
  bool centerText = true,
  double borderRadius = 32,
  Color? circleTextColor = AppColors.primaryColor,
  // New parameter to control text alignment
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      height: height,
      width: width,
      decoration: circle
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: circleColor!, width: 2.3),
            )
          : BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(32),
            ),
      child: Row(
        mainAxisAlignment: centerText
            ? MainAxisAlignment.center
            : MainAxisAlignment.start, // Conditional alignment for text
        children: [
          if (showIcon) ...[
            Icon(
              Icons.add,
              color: AppColors.primaryColor,
              size: 24,
            ),
            buildSizedBoxWidthFun(context, width: 5),
          ],
          buildSizedBoxWidthFun(context,
              width: centerText ? 5 : 16), // Add padding for left alignment
          buildTextFun(
            context,
            text,
            fontSize: 16, // Use the parameter instead of hardcoded value
            fontWeight: fontWeight,
            color: circle ? circleTextColor! : fontColor!,
          ),
        ],
      ),
    ),
  );
}


Widget buildTextFormFieldFun({
  required BuildContext context,
  required String text,
  required String hintText,
  TextEditingController? controller,
  bool isSmallSize = true,
  double? fontSize,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  bool isPassword = false,
  String? prefixImage,
  bool isHeightSize = true,
  bool isMediumSize = true,
  bool isWidthSize = true,
  bool dropdown = false,
  bool textColors = true,
  bool prefixColor = true,
  List<String>? dropdownItems,
  ValueChanged<String?>? onChanged,
  RxString? selectedValue,
  double borderRadius = 10.0, // Add this parameter to bind the selected value
}) {
  bool obscureText = isPassword;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Field Label
      buildTextFun(
        context,
        text,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColors ? Colors.black : AppColors.primaryColor,
      ),
      buildSizedBoxHeightFun(context, height: 6),
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: isHeightSize
                ? 56
                : isMediumSize
                    ? 194
                    : 40,
            width: isWidthSize ? 343 : 166,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: dropdown
                ? Obx(() {
                    return DropdownButtonFormField<String>(
                      value: selectedValue?.value.isEmpty ?? true
                          ? null
                          : selectedValue?.value,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0,
                        ),
                        prefixIcon: prefixImage != null
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: buildImageFun(context, prefixImage,
                                    height: 20, width: 20),
                              )
                            : null,
                      ),
                      dropdownColor: Colors.white,
                      menuMaxHeight: 100,
                      hint: Text(
                        hintText,
                        style: TextStyle(
                          fontSize: fontSize ?? 14,
                          color: AppColors.grey,
                        ),
                      ),
                      items: dropdownItems
                          ?.map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (selectedValue != null) {
                          selectedValue.value = value ?? '';
                        }
                        if (onChanged != null) {
                          onChanged(value);
                        }
                      },
                    );
                  })
                : TextFormField(
                    controller: controller,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    obscureText: isPassword ? obscureText : false,
                    maxLines: isHeightSize ? 1 : null,
                    maxLength: isHeightSize ? null : 500,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: fontSize ?? 14,
                        color: AppColors.grey,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0,
                      ),
                      prefixIcon: prefixImage != null
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: buildImageFun(context, prefixImage,
                                  height: 20,
                                  width: 20,
                                  color: prefixColor
                                      ? AppColors.black
                                      : AppColors.primaryColor),
                            )
                          : null,
                      suffixIcon: isPassword
                          ? IconButton(
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                            )
                          : null,
                    ),
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
          );
        },
      ),
    ],
  );
}

void buildScaffoldSuccessMessage(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50.0,
      left: 20.0,
      right: 20.0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 10), // Spacing between icon and text
              Expanded(
                child: buildTextFun(context, message,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundWhite),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

void buildScaffoldErrorMessage(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50.0,
      left: 20.0,
      right: 20.0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 10), // Spacing between icon and text
              Expanded(
                child: buildTextFun(context, message,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundWhite),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

//------------------Login Functions-------------------//
buildLoginButtonFun(BuildContext context, AuthController authController) {
  return Column(
    children: [
      buildContainerButtonFun(context, AppConstants.loginSmall,
          height: 50,
          width: MediaQuery.of(context).size.width,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryColor, onPressed: () {
        print('Login button clicked!');

        authController.login(context);
      }),
      buildSizedBoxHeightFun(context, height: 10),
      buildTextFun(
        context,
        AppConstants.dontHaveAccountRegister,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.grey,
        buttonpress: true,
        // This will make the text clickable
        onTap: () {
          print('Dont HaveAccountRegister Text clicked!');
          Get.toNamed(AppRouter.REGISTER_SCREEN);
        },
      )
    ],
  );
}

  buildLoginBodyFun(BuildContext context, AuthController authController) {
    return Column(
      children: [
        buildVaadagaiLogo(
          context,
          AppConstants.hrmLogo,
          height: 100,
          width: 120,
        ),
        buildTextFormFieldFun(
          context: context,
          text: AppConstants.emailAddress,
          hintText: AppConstants.enterEmailId,
          controller: authController.authEmailAddressController,
          keyboardType: TextInputType.emailAddress,
          isSmallSize: false,
        ),
        buildSizedBoxHeightFun(context, height: 20),
        buildTextFormFieldFun(
            context: context,
            text: AppConstants.password,
            hintText: AppConstants.enterYourPassword,
            controller: authController.authPasswordController,
            isPassword: true,
            isSmallSize: false,
            inputFormatters: [LengthLimitingTextInputFormatter(8)]),

      ],
    );
  }

// buildAuthHeaderFun(BuildContext context, String title) {
//   return Column(
//     children: [
//        buildVaadagaiLogo(
//         context,
//         AppConstants.hrmLogo,
//         height: 120,
//         width: 120
//       ),
//       Center(
//         child: buildTextFun(
//           context,
//           title,
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           color: AppColors.black,
//         ),
//       ),
//     ],
//   );
// }

//-------------------Register Functions----------------------//

Widget buildAuthHeaderFun(BuildContext context, String title) {
  return Stack(
    children: [
      Container(
        height: 200,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors:  [AppColors.primaryColor, AppColors.lightPrimaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 30,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
        ),
      ),
    ],
  );
}


Widget buildCustomScrollbar({
  required Widget child,
  bool thumbVisibility = true,
  double thickness = 4.0,
  Radius radius = const Radius.circular(5),
}) {
  return Scrollbar(
    thumbVisibility: thumbVisibility,
    thickness: thickness,
    radius: radius,
    child: child,
  );
}

buildRegisterButtonFun(BuildContext context, AuthController authController) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildContainerButtonFun(context, AppConstants.registerSmall,
            fontSize: 16,
            height: 50,
            width: MediaQuery.of(context).size.width,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor, onPressed: () {
          print('Register button clicked!');
          authController.register(context);
        }),
        buildSizedBoxHeightFun(context, height: 5),
        buildTextFun(
          context,
          AppConstants.alreadyHaveAccountLogin,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.grey,
          buttonpress: true,
          // This will make the text clickable
          onTap: () {
            print('Dont HaveAccountRegister Text clicked!');
            Get.toNamed(AppRouter.LOGIN_SCREEN);
          },
        )
      ],
    ),
  );
}

buildRegisterBodyFun(BuildContext context, AuthController authController) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        buildTextFormFieldFun(
          context: context,
          text: AppConstants.name,
          hintText: AppConstants.enterYourName,
          controller: authController.authNameController,
          isSmallSize: false,
        ),
        buildSizedBoxHeightFun(context, height: 20),
        buildTextFormFieldFun(
          context: context,
          text: AppConstants.mobileNumber,
          hintText: AppConstants.enterTenDigitNumber,
          controller: authController.authMobileNumberController,
          keyboardType: TextInputType.phone,
          inputFormatters: [LengthLimitingTextInputFormatter(10)],
          isSmallSize: false,
        ),
        buildSizedBoxHeightFun(context, height: 20),
        buildTextFormFieldFun(
          context: context,
          text: AppConstants.emailAddress,
          hintText: AppConstants.enterEmailId,
          controller: authController.authEmailAddressController,
          keyboardType: TextInputType.emailAddress,
          isSmallSize: false,
        ),
        buildSizedBoxHeightFun(context, height: 20),
        buildTextFormFieldFun(
            context: context,
            text: AppConstants.password,
            hintText: AppConstants.enterYourPassword,
            controller: authController.authPasswordController,
            isPassword: true,
            isSmallSize: false,
            inputFormatters: [LengthLimitingTextInputFormatter(8)]),
        buildSizedBoxHeightFun(context, height: 20),
        buildTextFormFieldFun(
            context: context,
            text: AppConstants.confirmPassword,
            hintText: AppConstants.confirmPassword,
            controller: authController.authConfirmPasswordController,
            isPassword: true,
            isSmallSize: false,
            inputFormatters: [LengthLimitingTextInputFormatter(8)]),
        buildSizedBoxHeightFun(context, height: 20),
        buildTextFormFieldFun(
          context: context,
          text: AppConstants.position,
          hintText: AppConstants.enterYourPosition,
          controller: authController.authPositionController,
          isSmallSize: false,
        ),

      ],
    ),
  );
}
// top logo image function

Widget buildTopLogoFun(BuildContext context, String imageUrl,
    {double height = 100, double width = 100}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(4), // Optional, keeps square corner
    child: Image.asset(
      imageUrl,
      height: height,
      width: width,
      fit: BoxFit.contain, // Better for logos
    ),
  );
}

//----------------------------------ADD SALE-----------------------------//

buildAgentHeaderFun(BuildContext context, String addProperty) {
  return Column(
    crossAxisAlignment:
        CrossAxisAlignment.start, // Aligns children to the start
    children: [
      buildTopLogoFun(context, AppConstants.hrmLogo),
      buildSizedBoxHeightFun(context, height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                print('property add screen click');
                Get.back();
              },
              child: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 8), // Adds spacing between the icon and text
            buildTextFun(
              context,
              addProperty,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ],
        ),
      ),
    ],
  );
}






Widget widgetBuildText(String text, double fontSize, FontWeight fontWeight, Color color) {
  return Text(
    text,
    style: GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1, // Fixes unwanted spacing between lines
    ),
  );
}


Widget loadingProgress(BuildContext context) {
  return const Center(
    child: CircularProgressIndicator(
      backgroundColor: AppColors.primaryBlue,
      color: AppColors.white,
    ),
  );
}




String getTimeDifference(DateTime postTime) {
  final now = DateTime.now(); // current time
  final difference = now.difference(postTime); // post time = past time

  if (difference.inMinutes < 1) {
    return 'Just now'; // For less than a minute
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}';
  } else if (difference.inDays < 30) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '$months month${months > 1 ? 's' : ''}';
  } else {
    final years = (difference.inDays / 365).floor();
    return '$years year${years > 1 ? 's' : ''}';
  }
}

buildProfileHeaderFun(
    BuildContext context,
    String profile,
    {bool isTitleClickable = false, VoidCallback? onTitleTap}
    ) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildTopLogoFun(context, AppConstants.hrmLogo),
      buildSizedBoxHeightFun(context, height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                print('profile screen click');
                Get.back();
              },
              child: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 8),
            isTitleClickable
                ? GestureDetector(
              onTap: onTitleTap,
              child: buildTextFun(
                context,
                profile,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            )
                : buildTextFun(
              context,
              profile,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ],
        ),
      ),
    ],
  );
}


Widget buildPropertyAddHeaderFun(
  BuildContext context,
  String profile,
) {
  return Column(
    crossAxisAlignment:
        CrossAxisAlignment.start, // Aligns children to the start
    children: [
      buildTopLogoFun(context, AppConstants.hrmLogo),
      buildSizedBoxHeightFun(context, height: 16),
      Row(
        children: [
          GestureDetector(
            onTap: () {
              print('Property Details screen click');
              Get.back();
            },
            child: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 8), // Adds spacing between the icon and text
          buildTextFun(
            context,
            profile,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ],
      ),
    ],
  );
}

buildAgentChangePasswordButtonFun(
    BuildContext context,
    AuthController authController,
    ) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildContainerButtonFun(context, AppConstants.done,
            fontSize: 16,
            height: 50,
            width: MediaQuery.of(context).size.width,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor, onPressed: () {
              print('Done button clicked!');
              authController.changePassword(context);
              Get.find<AuthController>().changePassword(context);
            })
      ],
    ),
  );
}

buildAgentChangePasswordBodyFun(
    context,
    AuthController authController,
    ) {
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          buildTextFormFieldFun(
              context: context,
              text: AppConstants.oldPassword,
              hintText: AppConstants.enterOldPassword,
              controller: authController.authOldPasswordController,
              isPassword: true,
              isSmallSize: false,
              inputFormatters: [LengthLimitingTextInputFormatter(8)]),
          buildSizedBoxHeightFun(context, height: 20),
          buildTextFormFieldFun(
              context: context,
              text: AppConstants.newPassword,
              hintText: AppConstants.enterNewPassword,
              controller: authController.authNewPasswordController,
              isPassword: true,
              isSmallSize: false,
              inputFormatters: [LengthLimitingTextInputFormatter(8)]),
          buildSizedBoxHeightFun(context, height: 20),
          buildTextFormFieldFun(
              context: context,
              text: AppConstants.confirmNewPassword,
              hintText: AppConstants.confirmNewPassword,
              controller: authController.authConfirmNewPasswordController,
              isPassword: true,
              isSmallSize: false,
              inputFormatters: [LengthLimitingTextInputFormatter(8)])
        ],
      ),
    );
  }
}

//----------------- wave Image-----------------------//
class WaveHeader extends StatelessWidget {
  const WaveHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFF00156A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 90);
    var secondEndPoint = Offset(size.width, size.height - 60);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}




Widget buildClockInAndOutReminder(String title, String message) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    contentPadding: const EdgeInsets.all(16),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lottie animation at the top
          SizedBox(
            height: Get.height * 0.2,
            child: Lottie.asset(
              'assets/images/clockticking.json',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Get.width * 0.05,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00156A),
            ),
          ),
          const SizedBox(height: 12),

          // Message
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Get.width * 0.04,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 24),

          // Okay Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00156A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "Okay",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.backgroundWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.white,
  );
}

