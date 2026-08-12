import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:numynd/features/audio_screen/presentation/audio_screen.dart';
import 'package:numynd/features/auth/login_screen.dart';
import 'package:numynd/features/auth/otp_screen.dart';
import 'package:numynd/features/auth/reset_pass_screen.dart';
import 'package:numynd/features/auth/signup_screen.dart';
import 'package:numynd/features/profile_screen.dart/change_password_screen.dart';
import 'package:numynd/features/profile_screen.dart/update_profile_screen.dart';
import 'package:numynd/navigation_screen.dart';

final class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();
  static Routes get instance => _routes;

  // ################## Auth User ##################
  static const String loginScreen = '/loginScreen';
  static const String signupScreen = '/signupScreen';
  static const String forgetOTPScreen = '/forgetOTPScreen';
  static const String resetPasswordScreen = '/resetPasswordScreen';
  static const String navigationScreen = '/navigationScreen';
  static const String audioScreen = '/audioScreen';
  static const String changePasswordScreen = '/changePasswordScreen';
  static const String otpScreen = '/otpScreen';
  static const String updateProfileScreen = '/updateProfileScreen';
}

final class RouteGenerator {
  static final RouteGenerator _routeGenerator = RouteGenerator._internal();
  RouteGenerator._internal();
  static RouteGenerator get instance => _routeGenerator;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: LoginScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => LoginScreen());

      case Routes.signupScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: SignupScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => SignupScreen());

      case Routes.resetPasswordScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ResetPasswordScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => ResetPasswordScreen());

      case Routes.navigationScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: NavigationScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => NavigationScreen());

      case Routes.audioScreen:
        final args = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: AudioScreen(
                  id: args['id'],
                  title: args['title'],
                  description: args['description'],
                  audioURL: args['audioURL'],
                  imageURL: args['imageURL'],
                ),
                settings: settings)
            : CupertinoPageRoute(
                builder: (context) => AudioScreen(
                  id: args['id'],
                  title: args['title'],
                  description: args['description'],
                  audioURL: args['audioURL'],
                  imageURL: args['imageURL'],
                ),
              );

      case Routes.changePasswordScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: ChangePasswordScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => ChangePasswordScreen());

      case Routes.otpScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: OTPScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => OTPScreen());

      case Routes.updateProfileScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: UpdateProfileScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => UpdateProfileScreen());

      default:
        return null;
    }
  }
}

//  weenAnimationBuilder(
//   child: Widget,
//   tween: Tween<double>(begin: 0, end: 1),
//   duration: Duration(milliseconds: 1000),
//   curve: Curves.bounceIn,
//   builder: (BuildContext context, double _val, Widget child) {
//     return Opacity(
//       opacity: _val,
//       child: Padding(
//         padding: EdgeInsets.only(top: _val * 50),
//         child: child
//       ),
//     );
//   },
// );

class _FadedTransitionRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;

  _FadedTransitionRoute({required this.widget, required this.settings})
      : super(
          settings: settings,
          reverseTransitionDuration: const Duration(milliseconds: 1),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionDuration: const Duration(milliseconds: 1),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.ease,
              ),
              child: child,
            );
          },
        );
}

class ScreenTitle extends StatelessWidget {
  final Widget widget;

  const ScreenTitle({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: .5, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: widget,
    );
  }
}
