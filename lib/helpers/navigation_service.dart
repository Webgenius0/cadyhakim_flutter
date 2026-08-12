// import 'package:flutter/material.dart';

// final class NavigationService {
//   static final NavigationService _navigationService =
//       NavigationService._internal();
//   NavigationService._internal();
//   static NavigationService get instance => _navigationService;

//   static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//   static Future<dynamic> navigateTo(String routeName) =>
//       navigatorKey.currentState!.pushNamed(routeName);

//   static Future<dynamic> navigateToReplacement(String routeName) =>
//       navigatorKey.currentState!.pushReplacementNamed(routeName);

//   static Future<dynamic> popAndReplace(String routeName) async {
//     return await navigatorKey.currentState!.popAndPushNamed(routeName);
//   }

//   static Future<dynamic> navigateToUntilReplacement(String routeName) =>
//       navigatorKey.currentState!
//           .pushNamedAndRemoveUntil(routeName, (route) => false);

//   static Future<dynamic> navigateToWithArgs(
//     String routeName,
//     Map<String, dynamic>? map,
//   ) =>
//       navigatorKey.currentState!.pushNamed(routeName, arguments: map);

//   static Future<dynamic> popAndReplaceWihArgs(
//           String routeName, Map<String, dynamic>? map) =>
//       navigatorKey.currentState!.popAndPushNamed(routeName, arguments: map);

//   static Future<dynamic> navigateToWithObject(
//     String routeName,
//     Object? obj,
//   ) =>
//       navigatorKey.currentState!.pushNamed(routeName, arguments: obj);

//   static get goBack => navigatorKey.currentState!.pop();

//   static get goBeBack => navigatorKey.currentState!.canPop();

//   static get context => navigatorKey.currentContext;

//   static void goBackCall() {
//     navigatorKey.currentState?.pop();
//   }
// }

import 'package:flutter/material.dart';

final class NavigationService {
  static final NavigationService _navigationService =
      NavigationService._internal();
  NavigationService._internal();
  static NavigationService get instance => _navigationService;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic>? navigateTo(String routeName) {
    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!.pushNamed(routeName);
    }
    return null;
  }

  static Future<dynamic>? navigateToReplacement(String routeName) {
    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!.pushReplacementNamed(routeName);
    }
    return null;
  }

  static Future<dynamic>? popAndReplace(String routeName) async {
    if (navigatorKey.currentState != null) {
      return await navigatorKey.currentState!.popAndPushNamed(routeName);
    }
    return null;
  }

  static Future<dynamic>? navigateToUntilReplacement(String routeName) {
    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!
          .pushNamedAndRemoveUntil(routeName, (route) => false);
    }
    return null;
  }

  static Future<dynamic>? navigateToWithArgs(
    String routeName,
    Map<String, dynamic>? map,
  ) {
    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!.pushNamed(routeName, arguments: map);
    }
    return null;
  }

  static Future<dynamic>? popAndReplaceWihArgs(
      String routeName, Map<String, dynamic>? map) {
    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!
          .popAndPushNamed(routeName, arguments: map);
    }
    return null;
  }

  static Future<dynamic>? navigateToWithObject(
    String routeName,
    Object? obj,
  ) {
    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!.pushNamed(routeName, arguments: obj);
    }
    return null;
  }

  static get goBack => navigatorKey.currentState!.pop();

  static get goBeBack => navigatorKey.currentState!.canPop();

  static get context => navigatorKey.currentContext;

  static void goBackCall() {
    navigatorKey.currentState?.pop();
  }

  // For loading screen navigation to prevent stack accumulation
  static Future<dynamic>? navigateAndClearStack(String routeName) {
    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!
          .pushNamedAndRemoveUntil(routeName, (route) => false);
    }
    return null;
  }
}
