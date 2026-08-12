// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:numynd/assets_helper/app_fonts.dart';
import '../assets_helper/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;

  final String? prefixIcon; // 🔹 নতুন prefix Icon
  final String? leftIcon; // SVG prefix icon (পুরোনো)
  final String? rightIcon; // SVG suffix icon (পুরোনো)
  final IconData? suffixIcon; // 🔹 নতুন suffix Icon

  final int? maxline;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? toggleVisibility;
  final String? Function(String?)? validator;
  final Color? borderColor;
  final Color? fieldColor;
  final double? textSize;
  final TextAlign? textAlign;
  final double? height;
  final double? width;
  final double? bRadius;
  final GestureTapCallback? onTap;

  const CustomTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.prefixIcon, // ✅ constructor এ add হলো
    this.leftIcon,
    this.rightIcon,
    this.suffixIcon,
    this.maxline,
    this.isPassword = false,
    this.obscureText = false,
    this.toggleVisibility,
    this.validator,
    this.borderColor,
    this.fieldColor,
    this.textSize,
    this.textAlign = TextAlign.start,
    this.height = 55.0,
    this.width,
    this.onTap,
    this.bRadius,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height?.h ?? 60.h,
          width: widget.width?.w,
          decoration: BoxDecoration(
            color: widget.fieldColor ?? AppColor.cFFFFFF,
            borderRadius: widget.bRadius != null
                ? BorderRadius.circular(widget.bRadius!)
                : BorderRadius.circular(12.r),
            border: Border.all(
              color: widget.borderColor ??
                  (_errorText != null ? Colors.red : const Color(0xffe8e8e8)),
              width: 1.w,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              // 🔹 prefixIcon (normal IconData)
              if (widget.prefixIcon != null) ...[
                SvgPicture.asset(
                  widget.prefixIcon!,
                  color: AppColor.c979797,
                  height: 20.h,
                  width: 20.w,
                ),
                SizedBox(width: 10.w),
              ],

              // 🔹 leftIcon (SVG asset)
              if (widget.leftIcon != null) ...[
                SvgPicture.asset(widget.leftIcon!, height: 20.h, width: 20.w),
                SizedBox(width: 10.w),
              ],

              // 🔹 TextFormField
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  obscureText: widget.isPassword && widget.obscureText,
                  maxLines: widget.maxline ?? 1,
                  validator: (value) {
                    final error = widget.validator?.call(value);
                    setState(() {
                      _errorText = error;
                    });
                    return null;
                  },
                  style: TextFontStyle.textStyle12w400Lato.copyWith(
                    color: Colors.white,
                    fontSize: widget.textSize ?? 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  cursorColor: AppColor.cFFFFFF,
                  textAlign: widget.textAlign ?? TextAlign.start,
                  onTap: widget.onTap,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextFontStyle.textStyle12w400Lato.copyWith(
                      color: AppColor.cF7F7F7,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    errorText: null,
                    contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                  ),
                ),
              ),

              // 🔹 rightIcon (SVG asset)
              if (widget.rightIcon != null) ...[
                SizedBox(width: 12.w),
                SvgPicture.asset(widget.rightIcon!, height: 20.h, width: 20.w),
              ],

              // 🔹 password eye toggle
              if (widget.isPassword)
                GestureDetector(
                  onTap: widget.toggleVisibility,
                  child: Icon(
                    widget.obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColor.c979797,
                  ),
                ),

              // 🔹 suffixIcon (normal IconData)
              if (widget.suffixIcon != null) ...[
                SizedBox(width: 8.w),
                Icon(
                  widget.suffixIcon,
                  color: AppColor.c979797,
                  size: 22.sp,
                ),
              ],
            ],
          ),
        ),

        // 🔹 Error text
        if (_errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h, left: 8.w),
            child: Text(
              _errorText!,
              style: TextFontStyle.textStyle12w400Lato
                  .copyWith(color: Colors.red, fontSize: 12.sp),
            ),
          ),
      ],
    );
  }
}
