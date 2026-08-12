import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:numynd/assets_helper/app_icons.dart';

import '../assets_helper/app_colors.dart';
import '../assets_helper/app_fonts.dart';
import '../helpers/ui_helpers.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    this.subTitle,
    required this.title,
    this.onCallBack,
    this.leadingVisible = true,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.bottom,
    this.elevation = 4.0,
    this.shadowColor,
  });

  final String title;
  final VoidCallback? onCallBack;
  final bool leadingVisible;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final Color? shadowColor;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.cF3F5F7,
        // boxShadow: [
        //   BoxShadow(
        //     color: shadowColor ?? Colors.black.withOpacity(0.04),
        //     blurRadius: 6,
        //     spreadRadius: 1,
        //     offset: const Offset(0, 8),
        //   ),
        // ],
      ),
      child: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading:
            false, // Disable automatic leading to control it manually
        leading: leadingVisible
            ? Padding(
                padding: EdgeInsets.all(8.sp),
                child: InkWell(
                  onTap: onCallBack ?? () => Get.back(),
                  child: SvgPicture.asset(
                    AppIcons.backIcons,
                    height: 40.h,
                    width: 40.w,
                  ),
                ),
              )
            : null,
        backgroundColor: Colors.transparent,
        titleSpacing: 2.w,
        centerTitle: centerTitle,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // If leading is not visible, add an empty space to balance alignment
            if (!leadingVisible)
              SizedBox(width: 24.sp), // Matches typical icon size
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextFontStyle.textStyle12w400Lato.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.c000000,
                  ),
                ),
                if (subTitle != null) ...[
                  UIHelper.verticalSpace(4.h),
                  Text(
                    subTitle!,
                    style: TextFontStyle
                        .textStyle14w500SecondaryColorJosefinSans
                        .copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryColor2,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        actions: actions,
        bottom: bottom,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        bottom == null
            ? kToolbarHeight
            : kToolbarHeight + bottom!.preferredSize.height,
      );
}
