// // ignore_for_file: unused_catch_stack

// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:numynd/assets_helper/app_image.dart';
// import 'package:numynd/constants/app_constants.dart';
// import 'package:numynd/features/auth/login_screen.dart';
// import 'package:numynd/helpers/all_routes.dart';
// import 'package:numynd/helpers/navigation_service.dart';
// import 'package:numynd/navigation_screen.dart';
// import 'helpers/di.dart';
// import 'helpers/helper_methods.dart';
// import 'networks/dio/dio.dart';

// final class LoadingScreen extends StatefulWidget {
//   const LoadingScreen({super.key});

//   @override
//   State<LoadingScreen> createState() => _LoadingScreenState();
// }

// class _LoadingScreenState extends State<LoadingScreen> {
//   bool _isLoadingScreen = true;
//   bool _hasNavigated = false;

//   @override
//   void initState() {
//     loadInitialData();
//     super.initState();
//   }

//   Future<void> loadInitialData() async {
//     try {
//       await setInitValue();

//       // * access token from data storeage
//       final String? token = appData.read(kKeyAccessToken);
//       log('===================> 🪪 User Access Token: $token');

//       if (token != null) {
//         DioSingleton.instance.update(token);
//         log('📦 Token set in Dio headers: Bearer $token');
//       } else {
//         log('❌ Token is NULL in Loading screen');
//       }

//       if (appData.read(kKeyIsLoggedIn) == true) {
//         log('🔐 User is logged in');

//         final id = appData.read(kKeyUserID);
//         log('🆔 Logging User ID: $id');
//       } else {
//         log('🔓 User is NOT logged in');
//       }
//     } catch (e, st) {
//       log('❗ Error during loading: $e');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingScreen = false;
//         });
//       }
//     }
//   }

//   Future<bool> isTokenExpired(String? token) async {
//     if (token == null) return true;

//     try {
//       // Decode the token to check expiration
//       final parts = token.split('.');
//       if (parts.length != 3) return true;

//       final payload = jsonDecode(
//           utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
//       final expiry =
//           payload['exp'] as int?; // Token expiration time (UNIX timestamp)

//       if (expiry == null) return true;

//       final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
//       return now >= expiry;
//     } catch (e) {
//       log("Error decoding token: $e");
//       return true;
//     }
//   }

//   void navigateToLogin() {
//     appData.write(kKeyIsLoggedIn, false);
//     NavigationService.navigateTo(
//       Routes.loginScreen,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoadingScreen) {
//       return Scaffold(
//         body: Container(
//           width: double.infinity,
//           height: double.infinity, // background full screen
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(AppImages.splashScreen),
//               fit: BoxFit.cover, // পুরো স্ক্রিন কভার করবে
//             ),
//           ),
//         ),
//       );
//     } else {
//       final bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
//       if (isLoggedIn) {
//         // Navigate after build completes using replacement to avoid stack issues
//         if (!_hasNavigated) {
//           _hasNavigated = true;
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (mounted) {
//               NavigationService.navigateAndClearStack(Routes.navigationScreen);
//             }
//           });
//         }
//         // Return splash screen while navigating to avoid blank screen
//         return Scaffold(
//           body: Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(AppImages.splashScreen),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         );
//       } else {
//         bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
//         if (isLoggedIn) {
//           return const LoginScreen();
//         } else if (isLoggedIn) {
//           return NavigationScreen();
//         } else {
//           return const LoginScreen();
//         }
//       }
//     }
//   }
// }

// ignore_for_file: unused_catch_stack

// * --------------------------------------------------------------------------------
// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:numynd/assets_helper/app_image.dart';
// import 'package:numynd/constants/app_constants.dart';
// import 'package:numynd/helpers/all_routes.dart';
// import 'package:numynd/helpers/navigation_service.dart';
// import 'helpers/di.dart';
// import 'helpers/helper_methods.dart';
// import 'networks/dio/dio.dart';

// final class LoadingScreen extends StatefulWidget {
//   const LoadingScreen({super.key});

//   @override
//   State<LoadingScreen> createState() => _LoadingScreenState();
// }

// class _LoadingScreenState extends State<LoadingScreen> {
//   bool _isLoadingScreen = true;
//   bool _hasNavigated = false;

//   @override
//   void initState() {
//     super.initState();
//     loadInitialData();
//   }

//   Future<void> loadInitialData() async {
//     try {
//       await setInitValue();

//       // Access token from local storage
//       final String? token = appData.read(kKeyAccessToken);
//       final bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;

//       log('===================> 🪪 User Access Token: $token');
//       log('===================> 👤 User logged in status: $isLoggedIn');

//       if (token != null) {
//         DioSingleton.instance.update(token);
//         log('📦 Token set in Dio headers: Bearer $token');
//       } else {
//         log('❌ Token is NULL');
//       }

//       // Check token validity
//       if (isLoggedIn && token != null) {
//         final bool expired = await isTokenExpired(token);
//         if (expired) {
//           log('⚠️ Token expired. Logging out...');
//           await handleLogout();
//         }
//       } else {
//         log('🔓 User is NOT logged in or token missing.');
//         await handleLogout();
//       }
//     } catch (e, st) {
//       log('❗ Error during loading: $e');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingScreen = false;
//         });
//       }
//     }
//   }

//   Future<void> handleLogout() async {
//     // Clear all user data from local storage
//     await appData.remove(kKeyAccessToken);
//     await appData.remove(kKeyUserID);
//     await appData.write(kKeyIsLoggedIn, false);
//     log('✅ Cleared all user session data');
//   }

//   Future<bool> isTokenExpired(String? token) async {
//     if (token == null) return true;

//     try {
//       final parts = token.split('.');
//       if (parts.length != 3) return true;

//       final payload = jsonDecode(
//         utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
//       );

//       final expiry = payload['exp'] as int?;
//       if (expiry == null) return true;

//       final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
//       final expired = now >= expiry;
//       if (expired) log('⏰ Token has expired');
//       return expired;
//     } catch (e) {
//       log("❗ Error decoding token: $e");
//       return true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoadingScreen) {
//       // Splash screen while loading
//       return Scaffold(
//         body: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(AppImages.splashScreen),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       );
//     } else {
//       final bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
//       final String? token = appData.read(kKeyAccessToken);

//       // Proper logic
//       if (isLoggedIn && token != null) {
//         if (!_hasNavigated) {
//           _hasNavigated = true;
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (mounted) {
//               NavigationService.navigateAndClearStack(Routes.navigationScreen);
//             }
//           });
//         }
//         return splashPlaceholder();
//       } else {
//         if (!_hasNavigated) {
//           _hasNavigated = true;
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (mounted) {
//               NavigationService.navigateAndClearStack(Routes.loginScreen);
//             }
//           });
//         }
//         return splashPlaceholder();
//       }
//     }
//   }

//   Widget splashPlaceholder() {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(AppImages.splashScreen),
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }
// * -------------------------------------------------------------------------------
// File: lib/loading_screen.dart

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:numynd/assets_helper/app_image.dart';
import 'package:numynd/constants/app_constants.dart';
import 'package:numynd/helpers/all_routes.dart';
import 'package:numynd/helpers/navigation_service.dart';
import 'helpers/di.dart';
import 'helpers/helper_methods.dart';
import 'networks/dio/dio.dart';

final class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoadingScreen = true;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      await setInitValue();

      final String? token = appData.read(kKeyAccessToken);
      final bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;

      log('===================> 🪪 User Access Token: $token');
      log('===================> 👤 User logged in status: $isLoggedIn');

      if (token != null && token.isNotEmpty) {
        DioSingleton.instance.update(token);
        log('📦 Token set in Dio headers: Bearer $token');
      } else {
        log('❌ Token is NULL or EMPTY');
      }

      if (isLoggedIn && token != null && token.isNotEmpty) {
        final bool expired = await isTokenExpired(token);

        if (expired) {
          log('⚠️ Token expired. Logging out...');
          await handleLogout();
        } else {
          log('✅ Token valid. Auto login success');
        }
      } else {
        log('🔓 User is NOT logged in or token missing.');
        await handleLogout();
      }
    } catch (e, st) {
      log('❗ Error during loading: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingScreen = false;
        });
      }
    }
  }

  Future<void> handleLogout() async {
    await appData.remove(kKeyAccessToken);
    await appData.remove(kKeyUserID);
    await appData.write(kKeyIsLoggedIn, false);
    log('✅ Cleared all user session data');
  }

  Future<bool> isTokenExpired(String? token) async {
    if (token == null || token.isEmpty) return true;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      final expiry = payload['exp'] as int?;
      if (expiry == null) return true;

      final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      final expired = now >= expiry;
      if (expired) log('⏰ Token has expired');
      return expired;
    } catch (e) {
      log("❗ Error decoding token: $e");
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingScreen) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.splashScreen),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else {
      final bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
      final String? token = appData.read(kKeyAccessToken);

      // ✅ FIXED CONDITION (main issue)
      final bool canAutoLogin = isLoggedIn && token != null && token.isNotEmpty;

      if (canAutoLogin) {
        if (!_hasNavigated) {
          _hasNavigated = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              NavigationService.navigateAndClearStack(Routes.navigationScreen);
            }
          });
        }
        return splashPlaceholder();
      } else {
        if (!_hasNavigated) {
          _hasNavigated = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              NavigationService.navigateAndClearStack(Routes.loginScreen);
            }
          });
        }
        return splashPlaceholder();
      }
    }
  }

  Widget splashPlaceholder() {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.splashScreen),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
