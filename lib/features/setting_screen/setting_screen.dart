// ignore_for_file: deprecated_member_use
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:numynd/assets_helper/app_colors.dart';
import 'package:numynd/assets_helper/app_fonts.dart';
import 'package:numynd/assets_helper/app_icons.dart';
import 'package:numynd/assets_helper/app_image.dart';
import 'package:numynd/constants/app_constants.dart';
import 'package:numynd/features/profile_screen.dart/model/profile_model.dart';
import 'package:numynd/helpers/all_routes.dart';
import 'package:numynd/helpers/di.dart';
import 'package:numynd/helpers/navigation_service.dart';
import 'package:numynd/helpers/ui_helpers.dart';
import 'package:numynd/networks/api_acess.dart';
import 'package:numynd/networks/stream_cleaner.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isDailyResetOn = false;
  bool _isLoggingOut = false; // 🔹 for showing loader

  Future<void> _openLink(String link) async {
    final uri = Uri.parse(link);

    final ok = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // browser এ ওপেন হবে
    );

    if (!ok) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the link.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openTerms(String link) async {
    final uri = Uri.parse(link);

    final ok = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // browser এ ওপেন হবে
    );

    if (!ok) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the link.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      bool success = await postLogOutRX.logOut();

      await Future.delayed(const Duration(milliseconds: 300));

      if (success) {
        totalDataClean();
        appData.write(kKeyIsLoggedIn, false);

        // ✅ Navigate to login screen after success
        NavigationService.navigateToUntilReplacement(Routes.loginScreen);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoggingOut = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getProfileInfoRXObj.getProfileInfoRX();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.homeBg),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Settings',
                        style: TextFontStyle.textStyle12w400Lato.copyWith(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      UIHelper.verticalSpace(30.h),

                      // 🔹 Daily Reset Reminder
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              SvgPicture.asset(AppIcons.notificationIcon),
                              Text(
                                ' Daily Reset Reminder ',
                                style:
                                    TextFontStyle.textStyle12w400Lato.copyWith(
                                  color: AppColor.cFFFFFF,
                                  fontSize: 14.sp,
                                ),
                              ),
                              const Spacer(),
                              Switch(
                                value: _isDailyResetOn,
                                onChanged: (value) {
                                  setState(() {
                                    _isDailyResetOn = value;
                                    log("===> $_isDailyResetOn");
                                  });
                                },
                                activeColor: AppColor.cBFE1FF,
                              ),
                            ],
                          ),
                        ),
                      ),

                      UIHelper.verticalSpaceMedium,

                      // 🔹 Account
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Account',
                          style: TextFontStyle.textStyle12w400Lato.copyWith(
                            color: AppColor.cFFFFFF,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      UIHelper.verticalSpace(10.h),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: StreamBuilder<GetProfile>(
                          stream: getProfileInfoRXObj.getProfileInfoRx,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // 🔹 Show loading while data is being fetched
                              return SizedBox(
                                height: 100, // Adjust height to look balanced
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.cFFFFFF,
                                    strokeWidth: 2.5,
                                  ),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              // 🔹 Error state
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Failed to load profile info',
                                  style: TextFontStyle.textStyle12w400Lato
                                      .copyWith(
                                    color: Colors.redAccent,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              );
                            }

                            var profileData = snapshot.data?.data;

                            if (profileData == null) {
                              // 🔹 Empty data state
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'No profile data available',
                                  style: TextFontStyle.textStyle12w400Lato
                                      .copyWith(
                                    color: AppColor.cFFFFFF,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              );
                            }

                            // 🔹 Data loaded successfully
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Name',
                                        style: TextFontStyle.textStyle12w400Lato
                                            .copyWith(
                                          color: AppColor.cFFFFFF,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      Text(
                                        profileData.name ?? 'N/A',
                                        style: TextFontStyle.textStyle12w400Lato
                                            .copyWith(
                                          color: AppColor.cFFFFFF,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  UIHelper.verticalSpace(20.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Email',
                                        style: TextFontStyle.textStyle12w400Lato
                                            .copyWith(
                                          color: AppColor.cFFFFFF,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      Text(
                                        profileData.email ?? 'N/A',
                                        style: TextFontStyle.textStyle12w400Lato
                                            .copyWith(
                                          color: AppColor.cFFFFFF,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      UIHelper.verticalSpaceMedium,

                      // 🔹 Others
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Others',
                          style: TextFontStyle.textStyle12w400Lato.copyWith(
                            color: AppColor.cFFFFFF,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      UIHelper.verticalSpace(10.h),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => _openLink(
                                  'https://sites.google.com/view/numynd/privacy-policy',
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(AppIcons.privacyIcon),
                                    UIHelper.horizontalSpace(10.w),
                                    Text(
                                      'Privacy Policy',
                                      style: TextFontStyle.textStyle12w400Lato
                                          .copyWith(
                                        color: AppColor.cFFFFFF,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(AppIcons.nextIcon),
                                  ],
                                ),
                              ),
                              UIHelper.verticalSpace(20.h),
                              GestureDetector(
                                onTap: () => _openTerms(
                                  'https://sites.google.com/view/numynd/terms-and-conditions',
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(AppIcons.termsIcon),
                                    UIHelper.horizontalSpace(10.w),
                                    Text(
                                      'Terms of Service',
                                      style: TextFontStyle.textStyle12w400Lato
                                          .copyWith(
                                        color: AppColor.cFFFFFF,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(AppIcons.nextIcon),
                                  ],
                                ),
                              ),
                              UIHelper.verticalSpace(20.h),

                              // 🔹 Logout button with loader
                              GestureDetector(
                                onTap: _isLoggingOut ? null : _handleLogout,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(AppIcons.logoutIcon),
                                    UIHelper.horizontalSpace(10.w),
                                    Text(
                                      'Log out',
                                      style: TextFontStyle.textStyle12w400Lato
                                          .copyWith(
                                        color: AppColor.cFFFFFF,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(AppIcons.nextIcon),
                                  ],
                                ),
                              ),

                              UIHelper.verticalSpaceMedium,
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirm Deletion'),
                                      content: const Text(
                                        'Are you sure you want to delete your account? This action cannot be undone.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            bool success =
                                                await postDeleteAccountRX
                                                    .deleteAccount();

                                            if (success) {
                                              totalDataClean();
                                              appData.write(
                                                  kKeyIsLoggedIn, false);

                                              // ✅ Navigate to login screen after success
                                              NavigationService
                                                  .navigateToUntilReplacement(
                                                      Routes.loginScreen);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Failed to delete account. Please try again.'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.deleteIcon,
                                      height: 20,
                                      width: 20,
                                      color: AppColor.bgColor,
                                    ),
                                    UIHelper.horizontalSpace(10.w),
                                    Text(
                                      'Delete Account',
                                      style: TextFontStyle.textStyle12w400Lato
                                          .copyWith(
                                        color: AppColor.cFFFFFF,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(AppIcons.nextIcon),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      UIHelper.verticalSpace(10.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // 🔹 Full-screen loader overlay
        if (_isLoggingOut)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.6),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
