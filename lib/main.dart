// ignore_for_file: deprecated_member_use, avoid_print
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:numynd/firebase_options.dart';
import 'package:numynd/loading_screen.dart';
import 'package:numynd/networks/dio/dio.dart';
import 'package:numynd/networks/internet_checker/internet_checker_controller.dart';
import 'package:provider/provider.dart';
import 'helpers/all_routes.dart';
import 'helpers/di.dart';
import 'helpers/helper_methods.dart';
import 'helpers/navigation_service.dart';
import 'helpers/register_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // remove black
      statusBarIconBrightness: Brightness.light, // or light
    ),
  );
  Get.put(InternetController(), permanent: true);
  try {
    print('Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  await GetStorage.init();
  diSetup();
  DioSingleton.instance.create();

  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    rotation();
    setInitValue();
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        showMaterialDialog(context);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return const UtillScreenMobile();
        },
      ),
    );
  }
}

class UtillScreenMobile extends StatelessWidget {
  const UtillScreenMobile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context),
              child: widget!,
            );
          },
          navigatorKey: NavigationService.navigatorKey,
          onGenerateRoute: RouteGenerator.generateRoute,
          home: LoadingScreen(),
        );
      },
    );
  }
}
