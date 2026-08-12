// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class TextFontStyle {
  TextFontStyle._();

  static final textStyle12w400Lato = TextStyle(
    color: const Color(0xFF888E9C) /* Neutral-N90 */,
    fontSize: 12.sp,
    fontFamily: 'Lato',
    height: 1.32,
    fontWeight: FontWeight.w400,
  );

  static final textStyle12w400LatoItalic = TextStyle(
    color: const Color(0xFF888E9C) /* Neutral-N90 */,
    fontSize: 12,
    fontFamily: 'Lato-Italic',
    height: 1.32,
    fontWeight: FontWeight.w400,
  );

  static final textStyle12w400LatoThinItalic = TextStyle(
    color: const Color(0xFF888E9C) /* Neutral-N90 */,
    fontSize: 12,
    fontFamily: 'Lato-ThinItalic',
    height: 1.32,
    fontWeight: FontWeight.w400,
  );

  static final textStyle12w400NunitoSans = TextStyle(
    color: const Color(0xFF888E9C) /* Neutral-N90 */,
    fontSize: 12,
    fontFamily: 'Nunito',
    height: 1.32,
    fontWeight: FontWeight.w400,
  );

  static final textStyle20w600primaryColor2JosefinSans = TextStyle(
    color: const Color(0xFF888E9C) /* Neutral-N90 */,
    fontSize: 20,
    fontFamily: 'Josefin Sans',
    fontWeight: FontWeight.w600,
    height: 1.50,
  );

  static final textStyle16w700primaryColor2JosefinSans = TextStyle(
    color: const Color(0xFF888E9C) /* Neutral-N90 */,
    fontSize: 16,
    fontFamily: 'Josefin Sans',
    fontWeight: FontWeight.w700,
    height: 1.50,
  );
  static final textStyle14w500SecondaryColorJosefinSans = TextStyle(
    color: const Color(0xFF888E9C) /* Neutral-N90 */,
    fontSize: 14,
    fontFamily: 'Josefin Sans',
    fontWeight: FontWeight.w500,
    height: 1.50,
  );

  static final textStyle20w600c000A15ColorJosefinSans = TextStyle(
    color: const Color(0xFF888E9C) /* Neutral-N90 */,
    fontSize: 20,
    fontFamily: 'Josefin Sans',
    fontWeight: FontWeight.w600,
    height: 1.50,
  );

  static var textStyle14w400c333333 = GoogleFonts.poppins(
    color: AppColor.c333333,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );
  static var textStyle14w500c242424 = GoogleFonts.poppins(
    color: AppColor.c242424,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );
  static var textStyle16w400c5C5C5C = GoogleFonts.poppins(
    color: AppColor.c5C5C5C,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );
  static var textStyle16w600cFFFFFF = GoogleFonts.poppins(
    color: AppColor.cFFFFFF,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );
  static var textStyle18w500c333333 = GoogleFonts.poppins(
    color: AppColor.c333333,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );

  static var headline18w500cFFFFFF = GoogleFonts.poppins(
    color: AppColor.cFFFFFF,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );

  static var textStyle14w400c6B6B6B = GoogleFonts.poppins(
    color: AppColor.c6B6B6B,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  /// ================= poppins ====================

  static var poppins10W400 = TextStyle(
      fontFamily: 'poppins',
      fontFamilyFallback: const [
        'Open Sans',
        'Roboto',
        'Noto Sans',
      ],
      color: Colors.white,
      fontSize: 10.sp,
      height: 1.50,
      fontWeight: FontWeight.w400);

  static var poppins10W500 = TextStyle(
      fontFamily: 'poppins',
      fontFamilyFallback: const [
        'Open Sans',
        'Roboto',
        'Noto Sans',
      ],
      color: Colors.white,
      fontSize: 10.sp,
      height: 1.50,
      fontWeight: FontWeight.w500);

  static var poppins10W600 = TextStyle(
      fontFamily: 'poppins',
      fontFamilyFallback: const [
        'Open Sans',
        'Roboto',
        'Noto Sans',
      ],
      color: Colors.white,
      fontSize: 10.sp,
      height: 1.50,
      fontWeight: FontWeight.w600);

  static var poppins10W700 = TextStyle(
      fontFamily: 'poppins',
      fontFamilyFallback: const [
        'Open Sans',
        'Roboto',
        'Noto Sans',
      ],
      color: Colors.white,
      fontSize: 10.sp,
      height: 1.50,
      fontWeight: FontWeight.w700);

  static var poppins10W800 = TextStyle(
      fontFamily: 'poppins',
      fontFamilyFallback: const [
        'Open Sans',
        'Roboto',
        'Noto Sans',
      ],
      color: Colors.white,
      fontSize: 10.sp,
      height: 1.50,
      fontWeight: FontWeight.w800);

  /// =========================== Inter ======================= ///
  static var Inter10W400 = TextStyle(
      fontFamily: 'Inter',
      fontFamilyFallback: const [
        'Open Sans',
        'Roboto',
        'Noto Sans',
      ],
      color: Colors.white,
      fontSize: 10.sp,
      height: 1.50,
      fontWeight: FontWeight.w400);

  static var Inter10W500 = TextStyle(
      fontFamily: 'Inter',
      fontFamilyFallback: const [
        'Open Sans',
        'Roboto',
        'Noto Sans',
      ],
      color: Colors.white,
      fontSize: 10.sp,
      height: 1.50,
      fontWeight: FontWeight.w500);

  static var Inter10W600 = TextStyle(
      fontFamily: 'Inter',
      fontFamilyFallback: const [
        'Open Sans',
        'Roboto',
        'Noto Sans',
      ],
      color: Colors.white,
      fontSize: 10.sp,
      height: 1.50,
      fontWeight: FontWeight.w600);

  static var Inter10W700 = TextStyle(
      fontFamily: 'Inter',
      fontFamilyFallback: const [
        'Open Sans',
        'Roboto',
        'Noto Sans',
      ],
      color: Colors.white,
      fontSize: 10.sp,
      height: 1.50,
      fontWeight: FontWeight.w700);

  static var Inter10W800 = TextStyle(
      fontFamily: 'Inter',
      fontFamilyFallback: const [
        'Open Sans',
        'Roboto',
        'Noto Sans',
      ],
      color: Colors.white,
      fontSize: 10.sp,
      height: 1.50,
      fontWeight: FontWeight.w800);
}
