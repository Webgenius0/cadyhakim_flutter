// ##################################################################
// ################### Emon Written Code, working code ##############
// ##################################################################

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:numynd/helpers/di.dart';
// import '../../constants/app_constants.dart';

// class NotificationService {
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   final _androidChannel = const AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: "This is notification description",
//     importance: Importance.defaultImportance,
//   );

//   final _localNotification = FlutterLocalNotificationsPlugin();

//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;
//   }

//   Future initLocalNotification() async {
//     const ios = DarwinInitializationSettings();
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const settings = InitializationSettings(android: android, iOS: ios);

//     await _localNotification.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (payload) {
//         final message = RemoteMessage.fromMap(jsonDecode(payload.toString()));
//         handleMessage(message);
//       },
//     );

//     final platform = _localNotification.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//     await platform?.createNotificationChannel(_androidChannel);
//   }

//   Future initPushNotification() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // Handle when app is launched initially via a notification
//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

//     // Handle when the app is opened via a notification
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

//     // Handle background messages
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

//     // Handle foreground notifications
//     FirebaseMessaging.onMessage.listen((message) {
//       final notification = message.notification;
//       if (notification != null) {
//         // Display local notification for foreground messages
//         _localNotification.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               _androidChannel.id,
//               _androidChannel.name,
//               channelDescription: _androidChannel.description,
//               icon: '@mipmap/ic_launcher',
//             ),
//             iOS: const DarwinNotificationDetails(),
//           ),
//           payload: jsonEncode(message.data),
//         );
//       }
//     });
//   }

//   Future<void> handleBackgroundMessage(RemoteMessage message) async {
//     log("Title ${message.notification?.title ?? ""}");
//     log("Body ${message.notification?.body ?? ""}");
//     log("data ${message.data}");
//   }

//   Future<void> initNotification() async {
//     try {
//       // Request permission for notifications
//       await _firebaseMessaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );

//       String? fcmToken;

//       // Platform-specific handling for token retrieval

//       if (Platform.isIOS) {
//         log("Come here");
//         log(FirebaseMessaging.instance.toString());
//         final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//         //  Fluttertoast.showToast(msg: apnsToken.toString());
//         fcmToken = await _firebaseMessaging.getToken();
//         log("FCM Token is =======> $fcmToken");

//         // Fluttertoast.showToast(msg: fcmToken.toString());

//         if (apnsToken != null) {
//           fcmToken = apnsToken;
//           fcmToken = await _firebaseMessaging.getToken();
//           log("FCM Token =====>>> $fcmToken");
//           log("APNS Token =====>>> $apnsToken");
//         } else {
//           log("Error: APNS token is not set.");
//         }
//       } else {
//         fcmToken = await _firebaseMessaging.getToken();
//         log("FCM Token =====>>> $fcmToken");
//       }

//       log("Device ID =====>>> ${appData.read(kKeyDeviceID)}");
//     } catch (e) {
//       log("Error initializing notifications: $e");
//     }

//     initPushNotification();
//     initLocalNotification();
//   }
// }

// #######################################################################################
// ################### My Written Code, Notification Showing on App using getx snackbar ##
// #######################################################################################
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:numynd/helpers/di.dart';
// import '../../constants/app_constants.dart';

// class NotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   final AndroidNotificationChannel _androidChannel =
//       const AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: "This channel is used for important notifications",
//     importance: Importance.max,
//   );

//   final FlutterLocalNotificationsPlugin _localNotification =
//       FlutterLocalNotificationsPlugin();

//   // Handle tap
//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;

//     log("Tapped Notification Data => ${message.data}");
//   }

//   // LOCAL NOTIFICATION INIT
//   Future initLocalNotification() async {
//     const ios = DarwinInitializationSettings();
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');

//     const settings = InitializationSettings(android: android, iOS: ios);

//     await _localNotification.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (response) {
//         if (response.payload != null) {
//           handleMessage(
//             RemoteMessage(data: jsonDecode(response.payload!)),
//           );
//         }
//       },
//     );

//     // Create channel
//     final androidPlatform =
//         _localNotification.resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();

//     await androidPlatform?.createNotificationChannel(_androidChannel);
//   }

//   // PUSH NOTIFICATION INIT
//   Future initPushNotification() async {
//     /// FOREGROUND notification popup settings for iOS
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       sound: true,
//       badge: true,
//     );

//     /// Terminated state
//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

//     /// Background state
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

//     /// Background handler
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

//     /// FOREGROUND LISTENER → WE WILL SHOW GETX SNACKBAR
//     FirebaseMessaging.onMessage.listen((message) {
//       log("🔥 Foreground notification received");

//       final notification = message.notification;
//       final title = notification?.title ?? "New Message";
//       final body = notification?.body ?? "You have a new notification";

//       // 🔥 Show GETX SNACKBAR instead of system notification
//       Get.snackbar(
//         title,
//         body,
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: const Color(0xFF1E1E1E),
//         colorText: const Color(0xFFFFFFFF),
//         margin: const EdgeInsets.all(12),
//         borderRadius: 12,
//         duration: const Duration(seconds: 3),
//         animationDuration: const Duration(milliseconds: 400),
//         overlayBlur: 1.5,
//         dismissDirection: DismissDirection.up,
//       );

//       // 🔥 Still show normal local notification for Android background compatibility
//       _localNotification.show(
//         message.hashCode,
//         title,
//         body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             _androidChannel.id,
//             _androidChannel.name,
//             channelDescription: _androidChannel.description,
//             priority: Priority.high,
//             importance: Importance.max,
//             icon: '@mipmap/ic_launcher',
//           ),
//           iOS: const DarwinNotificationDetails(),
//         ),
//         payload: jsonEncode(message.data),
//       );
//     });
//   }

//   // BACKGROUND handler
//   static Future<void> handleBackgroundMessage(RemoteMessage message) async {
//     log("📩 Background Message");
//     log("Title: ${message.notification?.title}");
//     log("Body: ${message.notification?.body}");
//     log("Data: ${message.data}");
//   }

//   // INIT ALL NOTIFICATION LOGIC
//   Future<void> initNotification() async {
//     try {
//       /// ASK PERMISSION (Android 13+ Required)
//       await _firebaseMessaging.requestPermission(
//         alert: true,
//         sound: true,
//         badge: true,
//       );

//       String? token = await _firebaseMessaging.getToken();
//       log("📌 FCM TOKEN = $token");

//       if (Platform.isIOS) {
//         final apns = await _firebaseMessaging.getAPNSToken();
//         log("📌 APNS TOKEN = $apns");
//       }

//       log("📌 Device ID: ${appData.read(kKeyDeviceID)}");
//     } catch (e) {
//       log("❌ Error initializing notifications: $e");
//     }

//     await initPushNotification();
//     await initLocalNotification();
//   }
// }

// #######################################################################################
// #######################################################################################

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:numynd/networks/api_acess.dart';
// import 'package:uuid/uuid.dart';

// import 'package:numynd/helpers/di.dart';
// import '../../../constants/app_constants.dart';

// class NotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   final AndroidNotificationChannel _androidChannel =
//       const AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: "This channel is used for important notifications",
//     importance: Importance.max,
//   );

//   final FlutterLocalNotificationsPlugin _localNotification =
//       FlutterLocalNotificationsPlugin();

//   // Handle tap
//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;
//     log("Tapped Notification Data => ${message.data}");
//   }

//   // LOCAL NOTIFICATION INIT
//   Future initLocalNotification() async {
//     const ios = DarwinInitializationSettings();
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');

//     const settings = InitializationSettings(android: android, iOS: ios);

//     await _localNotification.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (response) {
//         if (response.payload != null) {
//           handleMessage(
//             RemoteMessage(data: jsonDecode(response.payload!)),
//           );
//         }
//       },
//     );

//     final androidPlatform =
//         _localNotification.resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();

//     await androidPlatform?.createNotificationChannel(_androidChannel);
//   }

//   // PUSH NOTIFICATION INIT
//   Future initPushNotification() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       sound: true,
//       badge: true,
//     );

//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

//     FirebaseMessaging.onMessage.listen((message) {
//       log("🔥 Foreground notification received");

//       final notification = message.notification;
//       final title = notification?.title ?? "New Message";
//       final body = notification?.body ?? "You have a new notification";

//       Get.snackbar(
//         title,
//         body,
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: const Color(0xFF1E1E1E),
//         colorText: Colors.white,
//         margin: const EdgeInsets.all(12),
//         borderRadius: 12,
//         duration: const Duration(seconds: 3),
//         animationDuration: const Duration(milliseconds: 400),
//         overlayBlur: 1.5,
//         dismissDirection: DismissDirection.up,
//       );

//       _localNotification.show(
//         message.hashCode,
//         title,
//         body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             _androidChannel.id,
//             _androidChannel.name,
//             channelDescription: _androidChannel.description,
//             priority: Priority.high,
//             importance: Importance.max,
//             icon: '@mipmap/ic_launcher',
//           ),
//           iOS: const DarwinNotificationDetails(),
//         ),
//         payload: jsonEncode(message.data),
//       );
//     });
//   }

//   // BACKGROUND handler
//   static Future<void> handleBackgroundMessage(RemoteMessage message) async {
//     log("📩 Background Message");
//     log("Title: ${message.notification?.title}");
//     log("Body: ${message.notification?.body}");
//     log("Data: ${message.data}");
//   }

//   // INIT ALL NOTIFICATION LOGIC
//   Future<void> initNotification() async {
//     try {
//       await _firebaseMessaging.requestPermission(
//         alert: true,
//         sound: true,
//         badge: true,
//       );

//       String? token = await _firebaseMessaging.getToken();
//       log("📌 FCM TOKEN = $token");

//       if (Platform.isIOS) {
//         final apns = await _firebaseMessaging.getAPNSToken();
//         log("📌 APNS TOKEN = $apns");
//       }

//       /// ✅ UUID DEVICE ID GENERATE
//       final String deviceId = appData.read(kKeyDeviceID) ?? const Uuid().v4();

//       appData.write(kKeyDeviceID, deviceId);

//       log("📌 Device ID (UUID): $deviceId");

//       bool isSuccess = await postFCMRXObj.postFCMRX(
//         token: token,
//         deviceId: deviceId,
//       );

//       if (isSuccess) {
//         log("✅ FCM Token sent successfully to server.");
//       } else {
//         log("❌ Failed to send FCM Token to server.");
//       }
//     } catch (e) {
//       log("❌ Error initializing notifications: $e");
//     }

//     await initPushNotification();
//     await initLocalNotification();
//   }
// }

// #######################################################################################
// #######################################################################################

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:numynd/networks/api_acess.dart';
import 'package:uuid/uuid.dart';

import 'package:numynd/helpers/di.dart';
import '../../../constants/app_constants.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final AndroidNotificationChannel _androidChannel =
      const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: "This channel is used for important notifications",
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin _localNotification =
      FlutterLocalNotificationsPlugin();

  // Handle tap
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    log("Tapped Notification Data => ${message.data}");
  }

  // LOCAL NOTIFICATION INIT
  Future initLocalNotification() async {
    final ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    final settings = InitializationSettings(android: android, iOS: ios);

    await _localNotification.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          handleMessage(
            RemoteMessage(data: jsonDecode(response.payload!)),
          );
        }
      },
    );
  }

  // PUSH NOTIFICATION INIT
  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((message) {
      log("🔥 Foreground notification received");

      final notification = message.notification;
      final title = notification?.title ?? "New Message";
      final body = notification?.body ?? "You have a new notification";

      Get.snackbar(
        title,
        body,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
        animationDuration: const Duration(milliseconds: 400),
        overlayBlur: 1.5,
        dismissDirection: DismissDirection.up,
      );

      // iOS এ local notification show করার দরকার নেই কারণ
      // setForegroundNotificationPresentationOptions দিয়ে Firebase নিজেই দেখায়।
      // শুধু Android এ show করবো।
      if (Platform.isAndroid) {
        _localNotification.show(
          message.hashCode,
          title,
          body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              priority: Priority.high,
              importance: Importance.max,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });
  }

  // BACKGROUND handler
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    log("📩 Background Message");
    log("Title: ${message.notification?.title}");
    log("Body: ${message.notification?.body}");
    log("Data: ${message.data}");
  }

  // INIT ALL NOTIFICATION LOGIC
  Future<void> initNotification() async {
    try {
      // iOS এ permission request আরও বিস্তারিতভাবে handle করছি
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        sound: true,
        badge: true,
        announcement: false, // Siri announcement
        carPlay: false,
        criticalAlert: false,
        provisional: false, // true হলে silent permission পাবে
      );

      log("📋 iOS Permission Status: ${settings.authorizationStatus}");

      // Permission denied হলে early return
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        log("❌ Notification permission denied by user.");
        return;
      }

      String? token;

      if (Platform.isIOS) {
        // iOS এ FCM token পাওয়ার আগে APNS token নিশ্চিত করতে হয়।
        // অনেক সময় APNS token null আসে, তাই retry দিচ্ছি।
        String? apnsToken = await _firebaseMessaging.getAPNSToken();

        if (apnsToken == null) {
          log("⏳ APNS token null, 3 সেকেন্ড পর retry করছি...");
          await Future.delayed(const Duration(seconds: 3));
          apnsToken = await _firebaseMessaging.getAPNSToken();
        }

        log("📌 APNS TOKEN = $apnsToken");

        if (apnsToken != null) {
          token = await _firebaseMessaging.getToken();
        } else {
          log("❌ APNS token পাওয়া যায়নি, FCM token skip করা হলো।");
        }
      } else {
        token = await _firebaseMessaging.getToken();
      }

      log("📌 FCM TOKEN = $token");

      /// ✅ UUID DEVICE ID GENERATE
      final String deviceId = appData.read(kKeyDeviceID) ?? const Uuid().v4();
      appData.write(kKeyDeviceID, deviceId);
      log("📌 Device ID (UUID): $deviceId");

      if (token != null) {
        bool isSuccess = await postFCMRXObj.postFCMRX(
          token: token,
          deviceId: deviceId,
        );

        if (isSuccess) {
          log("✅ FCM Token sent successfully to server.");
        } else {
          log("❌ Failed to send FCM Token to server.");
        }
      }
    } catch (e) {
      log("❌ Error initializing notifications: $e");
    }

    await initPushNotification();
    await initLocalNotification();
  }
}
