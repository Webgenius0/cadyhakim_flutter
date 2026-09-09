// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:numynd/assets_helper/app_colors.dart';
import 'package:numynd/assets_helper/app_fonts.dart';
import 'package:numynd/assets_helper/app_image.dart';
import 'package:numynd/background_scafold.dart';
import 'package:numynd/common_widgets/custom_button.dart';
import 'package:numynd/common_widgets/custom_textfeild.dart';
import 'package:numynd/features/social_login/apple_login.dart';
import 'package:numynd/features/social_login/google_login.dart';
import 'package:numynd/helpers/all_routes.dart';
import 'package:numynd/helpers/navigation_service.dart';
import 'package:numynd/helpers/ui_helpers.dart';
import 'package:numynd/networks/api_acess.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  Future<void> _onLogin() async {
    final email = _emailCtrl.text.trim();
    final pass = _passwordCtrl.text;

    if (email.isEmpty || pass.isEmpty) {
      Get.snackbar(
        'Missing information',
        'Please enter email & password',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
      return;
    }

    final isGmail = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(email);
    if (!isGmail) {
      Get.snackbar(
        'Invalid email',
        'Use a valid Gmail address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      Get.snackbar(
        'Fix errors',
        'Please correct required fields',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool isSuccess =
          await postSigninRXObj.postSigninRX(email: email, password: pass);

      if (isSuccess) {
        if (mounted) {
          setState(() => _isLoading = false);
          NavigationService.navigateAndClearStack(Routes.navigationScreen);
        }
      } else {
        if (mounted) setState(() => _isLoading = false);

        Get.snackbar(
          'Login Failed',
          'Invalid credentials',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);

      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffolds(
      backgroundImage: AppImages.appBgOne,
      body: SingleChildScrollView(
        child: Column(
          children: [
            UIHelper.verticalSpace(20.h),
            // Logo
            Image.asset(
              AppImages.appLogo,
              height: 80.h,
              width: 80.w,
            ),

            UIHelper.verticalSpace(20.h),

            Text(
              'Welcome to NuMynd',
              style: TextFontStyle.textStyle12w400LatoItalic.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.cFFFFFF,
              ),
            ),

            UIHelper.verticalSpace(20.h),

            // Content container
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.c000000.withOpacity(0.5),
              ),
              child: Padding(
                padding: EdgeInsets.all(18.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Sign in to reset your spiral',
                        style: TextFontStyle.textStyle12w400Lato.copyWith(
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),

                      UIHelper.verticalSpace(20.h),

                      // Email
                      CustomTextField(
                        controller: _emailCtrl,
                        hintText: 'Email',
                        obscureText: false,
                        fieldColor: AppColor.c1B2630.withOpacity(0.3),
                        validator: (v) {
                          if ((v ?? '').trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$')
                              .hasMatch(v!.trim())) {
                            return 'Use valid Gmail';
                          }
                          return null;
                        },
                      ),

                      UIHelper.verticalSpace(10.h),

                      // Password
                      CustomTextField(
                        controller: _passwordCtrl,
                        hintText: 'Password',
                        isPassword: true,
                        obscureText: _obscurePassword,
                        toggleVisibility: _togglePasswordVisibility,
                        fieldColor: AppColor.c000000.withOpacity(0.3),
                        validator: (v) {
                          if ((v ?? '').isEmpty) {
                            return 'Password required';
                          }
                          if (v!.length < 6) {
                            return 'Minimum 6 characters';
                          }
                          return null;
                        },
                      ),

                      UIHelper.verticalSpace(8.h),

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            NavigationService.navigateTo(
                              Routes.resetPasswordScreen,
                            );
                          },
                          child: Text(
                            'Forget Password?',
                            style: TextFontStyle.textStyle12w400Lato.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      UIHelper.verticalSpace(20.h),

                      // Login Button
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
                                name: 'Log In',
                                onCallBack: _onLogin,
                                context: context,
                                color: AppColor.cEAF3FB,
                                textStyle:
                                    TextFontStyle.textStyle12w400Lato.copyWith(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),

                      UIHelper.verticalSpace(15.h),

                      if (Platform.isIOS)
                        CustomButton(
                          name: 'Continue with Guest',
                          onCallBack: () {
                            NavigationService.navigateTo(
                                Routes.navigationScreen);
                          },
                          context: context,
                          color: AppColor.cEAF3FB,
                          textStyle: TextFontStyle.textStyle12w400Lato.copyWith(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      UIHelper.verticalSpaceMedium,
                      Image.asset(AppImages.orImage),
                      UIHelper.verticalSpaceMedium,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (Platform.isAndroid)
                            GestureDetector(
                                onTap: () {
                                  SocialAuthData.signInWithGoogle(context);
                                },
                                child: Image.asset(AppImages.googleIcons)),
                          if (Platform.isIOS)
                            GestureDetector(
                              onTap: () {
                                SocialAuthApple.signInWithApple(context);
                              },
                              child: Image.asset(
                                AppImages.appleIcons,
                              ),
                            ),
                        ],
                      ),

                      UIHelper.verticalSpace(15.h),

                      InkWell(
                        onTap: () {
                          NavigationService.navigateTo(Routes.signupScreen);
                        },
                        child: Text(
                          "Don't have an account? Sign Up",
                          style: TextFontStyle.textStyle12w400Lato.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      UIHelper.verticalSpace(10.h),
                    ],
                  ),
                ),
              ),
            ),

            UIHelper.verticalSpace(20.h),
          ],
        ),
      ),
    );
  }
}
