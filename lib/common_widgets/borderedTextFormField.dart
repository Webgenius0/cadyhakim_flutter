// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../assets_helper/app_colors.dart';


class BorderedTextFormField extends StatefulWidget {
  final String hintText;
  final String? IconUrl;
  final String? prefixIconUrl;
  final int maxLine;
  final bool isIcon;
  final bool isPrefixIcon;
  final bool isPassword;
  final bool isBorder;
  final bool readOnly;
  final double width;
  final double borderRadius;
  final double? verticalPadding;
  final double? horaizontalPadding;
  final TextEditingController? textEditingController;
  final VoidCallback? onCallback;
  final String? Function(String?)? validator;
  final TextStyle textStyle;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final Color borderColor;
  final Color? fillColor;
  final Function(String)? onChanged;

  const BorderedTextFormField({
    super.key,
    required this.hintText,
    this.IconUrl,
    required this.isIcon,
    this.textEditingController,
    this.onCallback,
    this.isPassword = false,
    this.validator,
    required this.width,
    required this.maxLine,
    required this.textStyle,
    required this.isPrefixIcon,
    this.prefixIconUrl,
    this.textInputType,
    this.textInputAction,
    required this.borderColor,
    required this.borderRadius,
    required this.isBorder,
    this.verticalPadding,
    this.horaizontalPadding,
    this.fillColor,
    required this.readOnly,
    this.onChanged,
  });

  @override
  State<BorderedTextFormField> createState() => _BorderedTextFormFieldState();
}

class _BorderedTextFormFieldState extends State<BorderedTextFormField> {
  bool _isTextVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      //height: 60.h,
      /*  decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color:widget.borderColor )), */
      child: TextFormField(
        readOnly: widget.readOnly,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        //cursorHeight: 51.h,
        keyboardType: widget.textInputType,
        textInputAction: widget.textInputAction,
        maxLines: !widget.isPassword ? widget.maxLine : 1,
        validator: widget.validator,
        onTap: widget.onCallback,
        controller: widget.textEditingController,
        obscureText:
            widget.isPassword && !_isTextVisible, // Control visibility.

        style: widget.textStyle,
        cursorColor: AppColor.c000000,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor ?? AppColor.cFFFFFF,
          contentPadding: EdgeInsets.symmetric(
              vertical: widget.verticalPadding ?? 14.r,
              horizontal: widget.horaizontalPadding ?? 14.r), // Adjust padding

          hintText: widget.hintText,
          hintStyle: widget.textStyle,
          prefixIcon: widget.isPrefixIcon
              ? Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 10),
                  child: SvgPicture.asset(
                    widget.prefixIconUrl!,
                    height: 12,
                    width: 12,
                  ),
                )
              : null,
          suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: widget.isIcon == true
                  ? GestureDetector(
                      onTap: widget.onCallback,
                      child: SvgPicture.asset(widget.IconUrl!))
                  : widget.isPassword == true
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _isTextVisible =
                                  !_isTextVisible; // Toggle visibility.
                            });
                          },
                          child: Icon(
                            _isTextVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColor.c0D1E40,
                          ),
                        )
                      : Text('')),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: widget.isBorder == true
                  ? BorderSide(
                      color: widget.borderColor,
                    )
                  : const BorderSide(color: Colors.transparent)
              //AppColors.c838484
              //AppColors.allPrimaryColor),
              ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: widget.isBorder == true
                  ? BorderSide(
                      color: widget.borderColor,
                    )
                  : const BorderSide(color: Colors.transparent)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: const BorderSide(color: Colors.red),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            // borderSide: const BorderSide(color: AppColors.allPrimaryColor)
          ),
          /*  contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h), */
        ),
      ),
    );
  }
}
