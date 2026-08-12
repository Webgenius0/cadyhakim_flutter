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
import 'package:numynd/helpers/navigation_service.dart';
import 'package:numynd/helpers/ui_helpers.dart';
import 'package:numynd/networks/api_acess.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pastPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  // 👇 আলাদা আলাদা obscure flags
  bool _obscurePastPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  bool _isLoading = false;

  @override
  void dispose() {
    _pastPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _togglePastPasswordVisibility() {
    setState(() => _obscurePastPassword = !_obscurePastPassword);
  }

  // 👇 আলাদা টগল ফাংশন
  void _toggleNewPasswordVisibility() {
    setState(() => _obscureNewPassword = !_obscureNewPassword);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
  }

  Future<void> _onReset() async {
    final pastPassword = _pastPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmNewPassword = _confirmNewPasswordController.text.trim();

    if (pastPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmNewPassword.isEmpty) {
      Get.snackbar(
        'Missing information',
        'Please enter both password fields',
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

    // ডাবল-চেক: অবশ্যই ম্যাচ হতে হবে
    if (newPassword != confirmNewPassword) {
      Get.snackbar(
        'Password mismatch',
        'New password and confirmation do not match',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        backgroundColor: Colors.redAccent.withOpacity(0.95),
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Future.delayed(
        const Duration(
          seconds: 2,
        ),
      );

      bool isSuccess = await postResetPassApiRX.postResetPassRx(
        old_password: pastPassword,
        new_password: newPassword,
        new_password_confirmation: confirmNewPassword,
      );

      if (isSuccess) {
        setState(() => _isLoading = false);
      }

      Get.snackbar(
        'Success',
        'Password change successful',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
      NavigationService.goBack;
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
                  NavigationService.goBack; // ✅ কল করা হলো
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
                'Set a New Password',
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
                          'Create a strong password to secure your account',
                          style: TextFontStyle.textStyle12w400Lato.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColor.cFFFFFF,
                          ),
                        ),
                        UIHelper.verticalSpace(20.h),

                        CustomTextField(
                          controller: _pastPasswordController,
                          hintText: 'Previous password',
                          isPassword: true,
                          obscureText: _obscurePastPassword,
                          toggleVisibility:
                              _togglePastPasswordVisibility, // 👈 আলাদা টগল
                          fieldColor: AppColor.c000000.withOpacity(0.3),
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty)
                              return 'Previous Password required';
                            if (value.length < 6) return 'Minimum 6 characters';
                            return null;
                          },
                        ),

                        UIHelper.verticalSpace(15.h),

                        // 🔐 New password
                        CustomTextField(
                          controller: _newPasswordController,
                          hintText: 'New password',
                          isPassword: true,
                          obscureText: _obscureNewPassword,
                          toggleVisibility:
                              _toggleNewPasswordVisibility, // 👈 আলাদা টগল
                          fieldColor: AppColor.c000000.withOpacity(0.3),
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return 'Password required';
                            if (value.length < 6) return 'Minimum 6 characters';
                            return null;
                          },
                        ),

                        UIHelper.verticalSpace(15.h),

                        // 🔐 Confirm new password
                        CustomTextField(
                          controller: _confirmNewPasswordController,
                          hintText: 'Confirm new password',
                          isPassword: true,
                          obscureText: _obscureConfirmPassword,
                          toggleVisibility:
                              _toggleConfirmPasswordVisibility, // 👈 আলাদা টগল
                          fieldColor: AppColor.c000000.withOpacity(0.3),
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return 'Password required';
                            if (value.length < 6) return 'Minimum 6 characters';
                            if (value != _newPasswordController.text.trim()) {
                              return 'Passwords do not match';
                            }
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
                                  name: 'Update Password',
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
