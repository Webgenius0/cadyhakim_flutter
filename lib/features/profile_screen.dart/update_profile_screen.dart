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

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      Get.snackbar(
        'Missing information',
        'Please enter both name and email fields',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black.withOpacity(0.85),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      Get.snackbar(
        'Fix errors',
        'Please correct the highlighted fields',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.85),
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool isSuccess = await postUpdateProfileApiRX.postUpdateProfileRX(
        name: name,
        email: email,
      );

      if (isSuccess) {
        setState(() => _isLoading = false);

        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        getProfileInfoRXObj.getProfileInfoRX();
        NavigationService.goBack();
        return;
      } else {
        Get.snackbar(
          'Failed',
          'Profile update failed',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
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

              /// BACK BUTTON
              GestureDetector(
                onTap: () => NavigationService.goBack,
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
                'Update Profile Information',
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
                          'Update your profile information below',
                          style: TextFontStyle.textStyle12w400Lato.copyWith(
                            fontSize: 14.sp,
                            color: AppColor.cFFFFFF,
                          ),
                        ),

                        UIHelper.verticalSpace(20.h),

                        /// NAME FIELD
                        CustomTextField(
                          controller: _nameController,
                          hintText: 'Enter your name',
                          fieldColor: AppColor.c000000.withOpacity(0.3),
                        ),

                        UIHelper.verticalSpace(15.h),

                        /// EMAIL FIELD
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Enter your email',
                          fieldColor: AppColor.c000000.withOpacity(0.3),
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
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.6,
                                      ),
                                    ),
                                  ),
                                )
                              : CustomButton(
                                  name: 'Update Profile',
                                  onCallBack: _updateProfile,
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
