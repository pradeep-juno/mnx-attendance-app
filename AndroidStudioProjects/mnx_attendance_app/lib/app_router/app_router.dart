import 'package:get/get.dart';
import 'package:mnx_attendance_app/admin/admin_drawer_screen.dart';
import 'package:mnx_attendance_app/admin/notification_screen.dart';
import '../admin/leave_approval.dart';
import '../app_screens/New screens/Checkincheckoutscreen.dart';
import '../app_screens/New screens/annual_leave.dart';
import '../app_screens/New screens/approval_Queue_Screen.dart';
import '../app_screens/New screens/clockIn_Screen.dart';
import '../app_screens/New screens/missed_attendence_screen.dart';
import '../app_screens/New screens/notification_screen.dart';
import '../app_screens/login-register-splash screen/login_screen.dart';
import '../app_screens/navbar/bottom_nav_bar.dart';
import '../app_screens/navbar/dashboard_screen.dart';
import '../app_screens/navbar/leave_screen.dart';
import '../app_screens/onboard_screen/onboard_screen.dart';
import '../app_screens/profile_screen/agent_change_password_screen.dart';
import '../app_screens/profile_screen/agent_profile_screen.dart';
import '../app_screens/login-register-splash screen/register_screen.dart';
import '../app_screens/login-register-splash screen/splash_screen.dart';


class AppRouter {
  static const SPLASH_SCREEN = '/splash-screen';
  static const REGISTER_SCREEN = '/register-screen';
  static const LOGIN_SCREEN = '/login-screen';
  static const ONBOARD_SCREEN = '/onboard-screen-one';
  static const AGENT_MAIN_SCREEN = '/agent-main-screen';
  static const AGENT_PROFILE_SCREEN = '/agent-profile-screen';
  static const AGENT_CHANGE_PASSWORD_SCREEN = '/agent-change-password-screen';



  static const CLOCK_IN_SCREEN = '/clock-in-screen';
  static const ATTENDANCE_SUCCESS_SCREEN = '/attendance-success-screen';
  static const DASH_BOARD_SCREEN = '/dash-board-screen';
  static const NOTIFICATION_LIST_SCREEN = '/notification-list-screen';
  static const MAIN_NAVIGATION = '/main-navigation';
  static const CHECK_IN_OUT_SCREEN = '/check-in-screen';
  static const CHECK_OUT_SCREEN = '/check-out-screen';
  static const APPROVAL_QUEUE_SCREEN = '/app-request-screen';
  static const LEAVE_SCREEN = '/leave-screen';
  static const MISSED_ATTENDANCE_SCREEN = '/missed-attendance';
  static const CHECKIN_CHECKOUT_SCREEN  = '/checkin-checkout';
  static const ANNUAL_LEAVE  = '/annual-leave';
  static const EDIT_PROFILE_SCREEN  = '/edit-profile-screen';
  static const TERMS_AND_CONDITIONS  = '/terms-and-conditions';
  static const PRIVACY_POLICY  = '/privacy-policy';
  static const PROFILE_SCREEN  = '/profile-screen';
  static const ADMIN_HOME_SCREEN  = '/admin-home-screen';
  static const OTP_SCREEN  = '/otp-screen';
  static const LEAVE_APP  = '/leave-app';
  static const ADMIN_NOTIFICATION_SCREEN  = '/admin-notification-screen';
  static const ADMIN_LEAVE_APPROVAL_SCREEN  = '/admin-leave-approval-screen';
  static const ADMIN_SETTINGS_SCREEN  = '/admin-settings-screen';
  static const ADMIN_DRAWER  = '/admin-drawer-screen';

  static var routes = [
    GetPage(
      name: SPLASH_SCREEN,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: REGISTER_SCREEN,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: LOGIN_SCREEN,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AGENT_MAIN_SCREEN,
      page: () => MainNavigation(),
    ),
    GetPage(
      name: ONBOARD_SCREEN,
      page: () => OnboardScreen(),
    ),
    GetPage(
      name: AGENT_PROFILE_SCREEN,
      page: () => AgentProfileScreen(),
    ),
    GetPage(
      name: AGENT_CHANGE_PASSWORD_SCREEN,
      page: () => AgentChangePasswordScreen(),
    ),

    //------------------ NEW -----------------//

    GetPage(name: LOGIN_SCREEN, page: () => LoginScreen(),transition: Transition.fade),
    GetPage(name: CLOCK_IN_SCREEN, page: () => ClockInScreen(),transition:Transition.fade ),
    GetPage(name: DASH_BOARD_SCREEN, page: () => DashboardScreen(),transition:Transition.fade ),
    GetPage(name: NOTIFICATION_LIST_SCREEN, page: () => NotificationListScreen(),transition:Transition.fade ),
    GetPage(name: MAIN_NAVIGATION, page: () => MainNavigation(),transition:Transition.fade ),
    GetPage(name: APPROVAL_QUEUE_SCREEN, page: ()=> ApprovalQueueScreen(),transition:Transition.fade),
    GetPage(name: LEAVE_SCREEN, page: ()=> LeaveScreen(),transition:Transition.fade),
    GetPage(name: MISSED_ATTENDANCE_SCREEN, page: ()=> MissedAttendanceScreen(),transition:Transition.fade),
    GetPage(name: CHECK_IN_OUT_SCREEN, page: ()=> Checkincheckoutscreen(),transition:Transition.fade),
    GetPage(name: ANNUAL_LEAVE, page: ()=> AnnualLeave(),transition:Transition.fade),
    GetPage(name: LEAVE_APP, page: ()=> LeaveApp(),transition:Transition.fade),
    GetPage(name: ADMIN_NOTIFICATION_SCREEN, page: ()=> AdminNotificationScreen(),transition:Transition.fade),
    GetPage(name: ADMIN_LEAVE_APPROVAL_SCREEN, page: ()=> LeaveApp(),transition:Transition.fade),
    GetPage(
      name: ADMIN_DRAWER,
      page: () => AdminDrawer(),
    ),


  ];
}
