// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:numynd/assets_helper/app_colors.dart';
import 'package:numynd/assets_helper/app_fonts.dart';
import 'package:numynd/assets_helper/app_icons.dart';
import 'package:numynd/assets_helper/app_image.dart';
import 'package:numynd/common_widgets/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:numynd/helpers/all_routes.dart';
import 'package:numynd/helpers/navigation_service.dart';
import 'package:numynd/helpers/ui_helpers.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String otpCode = "";

  // 3:00 countdown for resend
  Duration _remaining = const Duration(minutes: 3);
  Timer? _timer;

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_remaining.inSeconds > 0) {
        setState(() => _remaining -= const Duration(seconds: 1));
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _onReset() async {
    // ✅ OTP check (from otpCode)
    final code = otpCode.trim();

    if (code.isEmpty ||
        code.length != 6 ||
        !RegExp(r'^\d{6}$').hasMatch(code)) {
      Get.snackbar(
        'Missing information',
        'Please enter the 6-digit code',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        backgroundColor: Colors.black.withOpacity(0.85),
        colorText: Colors.white,
        icon: const Icon(Icons.info_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // (optional) form-level validation hooks
    if (!(_formKey.currentState?.validate() ?? true)) {
      Get.snackbar(
        'Fix form errors',
        'Please correct the highlighted fields',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      log("Entered OTP: $code");
      await Future.delayed(const Duration(seconds: 2));
      _showMyDialog(context);
    } catch (e) {
      Get.snackbar(
        'Failed',
        '$e',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onResend() async {
    // Only allow when timer finished
    if (_remaining.inSeconds > 0) return;
    try {
      Get.snackbar(
        'Code sent',
        'A new code has been sent to your email',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white,
        icon: const Icon(Icons.mark_email_read, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
      setState(() => _remaining = const Duration(minutes: 3));
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) return;
        if (_remaining.inSeconds > 0) {
          setState(() => _remaining -= const Duration(seconds: 1));
        } else {
          t.cancel();
        }
      });
    } catch (e) {
      Get.snackbar(
        'Failed to resend',
        '$e',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    }
  }

  void _showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      useRootNavigator: false, // keep it within current page's navigator
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: AppColor.c282B34,
          content: SizedBox(
            width: 300.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(AppIcons.doneIcons),
                UIHelper.verticalSpace(20.h),
                Text(
                  'OTP Verified Successfully!',
                  style: TextFontStyle.textStyle12w400LatoItalic.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.cFFFFFF,
                  ),
                  textAlign: TextAlign.center,
                ),
                UIHelper.verticalSpace(10.h),
                Text(
                  'You’ve successfully verified your identity. Let’s continue to the next step.',
                  style: TextFontStyle.textStyle12w400Lato.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColor.cFFFFFF,
                  ),
                  textAlign: TextAlign.center,
                ),
                UIHelper.verticalSpace(20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CustomButton(
                    name: 'OK',
                    onCallBack: () {
                      Navigator.of(context).pop();
                      NavigationService.navigateToUntilReplacement(
                        Routes.loginScreen,
                      );
                    },
                    context: context,
                    color: AppColor.cEAF3FB,
                    textStyle: TextFontStyle.textStyle12w400Lato.copyWith(
                      color: AppColor.c000000,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                UIHelper.verticalSpace(12.h),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _remaining.inSeconds == 0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.appBgOne),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              UIHelper.verticalSpace(60.h),
              GestureDetector(
                onTap: () {
                  NavigationService.navigateToReplacement(Routes.loginScreen);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset(
                      AppIcons.backIcons,
                      height: 40.h,
                      width: 40.w,
                    ),
                  ),
                ),
              ),
              UIHelper.verticalSpace(20.h),
              Text(
                'OTP Verification',
                style: TextFontStyle.textStyle12w400LatoItalic.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.cFFFFFF,
                ),
              ),
              UIHelper.verticalSpace(40.h),
              Container(
                height: 500.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.c000000.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(18.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Enter the 6-digit code we sent to your email',
                          style: TextFontStyle.textStyle12w400Lato.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColor.cFFFFFF,
                          ),
                        ),
                        UIHelper.verticalSpace(20.h),

                        // ✅ OtpTextField stores code into otpCode
                        OtpTextField(
                          contentPadding: const EdgeInsets.all(20),
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          enabled: true,
                          numberOfFields: 6,
                          fieldWidth: 48.w,
                          cursorColor: AppColor.cFFFFFF,
                          fieldHeight: 50.h,
                          borderRadius: BorderRadius.circular(7.38.r),
                          showFieldAsBox: true,
                          filled: true,
                          textStyle: TextFontStyle.textStyle12w400Lato.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.cFFFFFF,
                          ),
                          fillColor: AppColor.cFFFFFF.withOpacity(0.1),
                          borderWidth: 1.0.w,
                          enabledBorderColor: AppColor.cDFE1E6,
                          borderColor: AppColor.cDFE1E6,
                          focusedBorderColor: AppColor.cFFFFFF,
                          onCodeChanged: (code) =>
                              setState(() => otpCode = code),
                          onSubmit: (verificationCode) {
                            setState(() => otpCode = verificationCode);
                            log("Entered OTP: $otpCode");
                          },
                        ),

                        UIHelper.verticalSpace(20.h),

                        // Countdown
                        Text(
                          _fmt(_remaining),
                          style: TextFontStyle.textStyle12w400Lato.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColor.cFFFFFF,
                          ),
                        ),

                        UIHelper.verticalSpace(10.h),

                        // Resend row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn’t receive code?",
                              style: TextFontStyle.textStyle12w400Lato.copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColor.cFFFFFF,
                              ),
                            ),
                            GestureDetector(
                              onTap: canResend ? _onResend : null,
                              child: Text(
                                "  Resend",
                                style:
                                    TextFontStyle.textStyle12w400Lato.copyWith(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w800,
                                  color: canResend
                                      ? AppColor.cFFFFFF
                                      : AppColor.cFFFFFF.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),

                        UIHelper.verticalSpace(20.h),

                        // Verify button
                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: _isLoading
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.cEAF3FB,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: const Center(
                                    child: SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator.adaptive(
                                        strokeWidth: 2.6,
                                      ),
                                    ),
                                  ),
                                )
                              : CustomButton(
                                  name: 'Verify',
                                  onCallBack: _onReset,
                                  context: context,
                                  color: AppColor.cEAF3FB,
                                  textStyle: TextFontStyle.textStyle12w400Lato
                                      .copyWith(
                                    color: AppColor.c000000,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),

                        UIHelper.verticalSpace(20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
