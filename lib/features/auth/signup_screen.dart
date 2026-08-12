import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; // ⬅️ GetX
import 'package:numynd/assets_helper/app_colors.dart';
import 'package:numynd/assets_helper/app_fonts.dart';
import 'package:numynd/assets_helper/app_image.dart';
import 'package:numynd/background_scafold.dart';
import 'package:numynd/common_widgets/custom_button.dart';
import 'package:numynd/common_widgets/custom_textfeild.dart';
import 'package:numynd/helpers/all_routes.dart';
import 'package:numynd/helpers/navigation_service.dart';
import 'package:numynd/helpers/ui_helpers.dart';
import 'package:numynd/networks/api_acess.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSignup() async {
    // 🔔 ফাঁকা হলে টপ থেকে GetX Snackbar
    final email = _emailCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    final pass = _passwordCtrl.text;

    if (email.isEmpty || pass.isEmpty || name.isEmpty) {
      final msg = email.isEmpty && pass.isEmpty && name.isEmpty
          ? 'Please enter email, name & password'
          : email.isEmpty
              ? 'Please enter your email'
              : name.isEmpty
                  ? 'Please enter your name'
                  : 'Please enter your password';

      Get.snackbar(
        'Missing information',
        msg,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        backgroundColor: Colors.black,
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

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      final success = await postSignupRXObj.postSignupRX(
        email: email,
        password: pass,
        name: name,
      );
      if (success) {
        Get.snackbar(
          'Signup Successful',
          'Welcome aboard, $name!',
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
        NavigationService.navigateTo(Routes.navigationScreen);
      } else {
        Get.snackbar(
          'Signup Failed',
          'Please try again later.',
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          backgroundColor: Colors.red.withOpacity(0.9),
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Login failed',
        '$e',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        backgroundColor: Colors.red.withOpacity(0.95),
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffolds(
      backgroundImage: AppImages.appBgOne,
      body: Column(
        children: [
          UIHelper.verticalSpace(20.h),
          Image.asset(
            AppImages.appLogo,
            height: 80.h,
            width: 80.w,
          ),
          UIHelper.verticalSpace(20.h),
          Text(
            'Create Your NuMynd Account',
            style: TextFontStyle.textStyle12w400LatoItalic.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.cFFFFFF,
            ),
          ),
          UIHelper.verticalSpace(40.h),

          // Glass container
          Container(
            height: 500.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColor.c000000.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sign in to reset your spiral',
                        style: TextFontStyle.textStyle12w400Lato.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColor.cFFFFFF,
                        ),
                      ),
                      UIHelper.verticalSpace(20.h),
                      CustomTextField(
                        controller: _nameCtrl,
                        hintText: 'Enter full name',
                        obscureText: false,
                        fieldColor: AppColor.c000000.withOpacity(0.3),
                      ),

                      UIHelper.verticalSpace(10.h),
                      // Email
                      CustomTextField(
                        controller: _emailCtrl,
                        hintText: 'Email',
                        obscureText: false,
                        fieldColor: AppColor.c000000.withOpacity(0.3),
                        validator: (v) {
                          if ((v ?? '').isEmpty) return 'Email is required';
                          if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(v!)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),

                      UIHelper.verticalSpace(10.h),

                      // Password with toggle
                      CustomTextField(
                        controller: _passwordCtrl,
                        hintText: 'Password',
                        isPassword: true,
                        obscureText: _obscurePassword,
                        toggleVisibility: _togglePasswordVisibility,
                        fieldColor: AppColor.c000000.withOpacity(0.3),
                        validator: (v) {
                          if ((v ?? '').isEmpty) return 'Password required';
                          if (v!.length < 6) return 'Minimum 6 characters';
                          return null;
                        },
                      ),

                      // UIHelper.verticalSpace(5.h),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: Text(
                      //     'Forget Password?',
                      //     style: TextFontStyle.textStyle12w400Lato.copyWith(
                      //       fontSize: 12.sp,
                      //       fontWeight: FontWeight.bold,
                      //       color: AppColor.cFFFFFF,
                      //     ),
                      //   ),
                      // ),

                      UIHelper.verticalSpace(20.h),

                      // Login Button OR Loader (same space)
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
                                name: 'Sign Up',
                                onCallBack: _onSignup,
                                context: context,
                                color: AppColor.cEAF3FB,
                                textStyle:
                                    TextFontStyle.textStyle12w400Lato.copyWith(
                                  color: AppColor.c000000,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),

                      UIHelper.verticalSpace(20.h),

                      InkWell(
                        onTap: () {
                          NavigationService.goBack;
                        },
                        child: Text(
                          'Already have an account? Log In',
                          style: TextFontStyle.textStyle12w400Lato.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColor.cFFFFFF,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
