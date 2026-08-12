// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:numynd/assets_helper/app_colors.dart';
import 'package:numynd/assets_helper/app_fonts.dart';
import 'package:numynd/assets_helper/app_icons.dart';
import 'package:numynd/assets_helper/app_image.dart';
import 'package:numynd/common_widgets/custom_button.dart';
import 'package:numynd/common_widgets/custom_textfeild.dart';
import 'package:numynd/helpers/all_routes.dart';
import 'package:numynd/helpers/navigation_service.dart';
import 'package:numynd/helpers/ui_helpers.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _onReset() async {
    final email = _emailCtrl.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Missing information',
        'Please enter your email',
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

    // Gmail-only guard
    final isGmail = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(email);
    if (!isGmail) {
      Get.snackbar(
        'Invalid email',
        'Use a valid Gmail address (e.g., name@gmail.com)',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // বাকি validator গুলোও চালু করা
    if (!(_formKey.currentState?.validate() ?? false)) {
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
      // এখানে তোমার reset password API কল হবে
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Password reset link sent to your email',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
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

  void _showMyDialog(BuildContext context) {
    // ডায়ালগ দেখাই
    showDialog(
      context: context,
      barrierDismissible: false, // বাইরে চাপলে বন্ধ হবে না
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: AppColor.c282B34,
          content: Container(
            height: 230.h, // বাটন বাদ, তাই একটু কম
            width: 300.w,
            decoration: BoxDecoration(
              color: AppColor.c282B34,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(AppIcons.doneIcons),
                UIHelper.verticalSpace(10.h),
                Text(
                  'Password reset link sent',
                  style: TextFontStyle.textStyle12w400LatoItalic.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.cFFFFFF,
                  ),
                  textAlign: TextAlign.center,
                ),
                UIHelper.verticalSpace(10.h),
                Text(
                  'Check your email for reset instructions!',
                  style: TextFontStyle.textStyle12w400Lato.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColor.cFFFFFF,
                  ),
                  textAlign: TextAlign.center,
                ),
                UIHelper.verticalSpace(12.h),
                Text(
                  'Redirecting to OTP…',
                  style: TextFontStyle.textStyle12w400Lato.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.cFFFFFF.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // ২ সেকেন্ড পর ডায়ালগ বন্ধ করে OTP স্ক্রিনে নেবে
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      // ডায়ালগ খোলা থাকলে আগে পপ
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      // তারপর OTP স্ক্রিনে
      NavigationService.navigateToUntilReplacement(Routes.otpScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  NavigationService.goBack;
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
                'Reset Password',
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
                          'Enter your email to reset password',
                          style: TextFontStyle.textStyle12w400Lato.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColor.cFFFFFF,
                          ),
                        ),
                        UIHelper.verticalSpace(20.h),
                        CustomTextField(
                          controller: _emailCtrl,
                          hintText: 'Email',
                          obscureText: false,
                          fieldColor: AppColor.c000000.withOpacity(0.3),
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return 'Email is required';
                            // শুধু gmail.com অনুমোদিত
                            final isGmail =
                                RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$')
                                    .hasMatch(value);
                            if (!isGmail)
                              return 'Use a valid Gmail address (e.g., name@gmail.com)';
                            return null;
                          },
                        ),
                        UIHelper.verticalSpace(20.h),
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
                                  name: 'Send Reset Link',
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
