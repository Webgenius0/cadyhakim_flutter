import 'package:flutter/material.dart';

class CustomizedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double height;
  final double width;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double borderRadius;

  const CustomizedButton({
    Key? key,
    required this.text,
    this.onTap,
    required this.height,
    required this.width,
    this.backgroundColor = const Color(0xffD5E7B0),
    required this.textStyle,
    this.borderRadius = 46,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0, // Optional: adds subtle shadow
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
