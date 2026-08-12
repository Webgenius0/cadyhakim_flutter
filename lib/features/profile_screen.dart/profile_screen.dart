// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:numynd/assets_helper/app_colors.dart';
import 'package:numynd/assets_helper/app_fonts.dart';
import 'package:numynd/assets_helper/app_icons.dart';
import 'package:numynd/assets_helper/app_image.dart';
import 'package:numynd/features/profile_screen.dart/model/profile_model.dart';
import 'package:numynd/helpers/all_routes.dart';
import 'package:numynd/helpers/navigation_service.dart';
import 'package:numynd/helpers/ui_helpers.dart';
import 'package:numynd/networks/api_acess.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    getProfileInfoRXObj.getProfileInfoRX();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity, // background full screen
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.homeBg),
            fit: BoxFit.cover, // পুরো স্ক্রিন কভার করবে
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(
                20,
              ),
              child: Column(
                children: [
                  Text(
                    'Profile',
                    style: TextFontStyle.textStyle12w400Lato.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  UIHelper.verticalSpace(20.h),
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: AssetImage(AppImages.appLogo),
                  ),
                  UIHelper.verticalSpace(20.h),
                  StreamBuilder<GetProfile>(
                    stream: getProfileInfoRXObj.getProfileInfoRx,
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          color: AppColor.cFFFFFF,
                        );
                      } else if (asyncSnapshot.hasError) {
                        return Text(
                          'Error loading name',
                          style: TextFontStyle.textStyle12w400Lato.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }

                      var profileName = asyncSnapshot.data?.data?.name;

                      return Text(
                        profileName ?? 'N/A',
                        style: TextFontStyle.textStyle12w400Lato.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  UIHelper.verticalSpace(20.h),
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
                              style: TextFontStyle.textStyle12w400Lato.copyWith(
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
                              style: TextFontStyle.textStyle12w400Lato.copyWith(
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
                  UIHelper.verticalSpace(20.h),
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
                            onTap: () {
                              NavigationService.navigateTo(
                                Routes.updateProfileScreen,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.editIcons,
                                ),
                                UIHelper.horizontalSpace(10.w),
                                Text(
                                  'Edit Profile',
                                  style: TextFontStyle.textStyle12w400Lato
                                      .copyWith(
                                    color: AppColor.cFFFFFF,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Spacer(),
                                SvgPicture.asset(
                                  AppIcons.nextIcon,
                                ),
                              ],
                            ),
                          ),
                          UIHelper.verticalSpace(20.h),
                          GestureDetector(
                            onTap: () {
                              NavigationService.navigateTo(
                                Routes.changePasswordScreen,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.lockIcons,
                                ),
                                UIHelper.horizontalSpace(10.w),
                                Text(
                                  'Change Password',
                                  style: TextFontStyle.textStyle12w400Lato
                                      .copyWith(
                                    color: AppColor.cFFFFFF,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Spacer(),
                                SvgPicture.asset(
                                  AppIcons.nextIcon,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
