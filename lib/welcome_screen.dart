import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'assets_helper/app_image.dart';

final class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Image.asset(
            AppImages.appLogo,
            fit: BoxFit.cover,
            height: 100.h,
            width: 100.w,
          ),
        ),
      ),
    );
  }
}
