import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:numynd/assets_helper/app_colors.dart';
import 'package:numynd/assets_helper/app_fonts.dart';
import 'package:numynd/assets_helper/app_icons.dart';

class FeelingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetImage; // e.g. 'assets/mountains.png'
  final VoidCallback? onBellTap;

  const FeelingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.assetImage,
    this.onBellTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      width: 340, // চাইলে responsive করুন
      child: Stack(
        children: [
          // Background image with rounded corners
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: CachedNetworkImage(
              imageUrl: assetImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade200,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade300,
                child: Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),

          // Left-to-right fade gradient overlay
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColor.cB5CAA9.withOpacity(0.95),
                    AppColor.cB5CAA9.withOpacity(0.30),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.35, 0.7],
                ),
              ),
            ),
          ),

          // Texts
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextFontStyle.textStyle12w400Lato.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextFontStyle.textStyle12w400Lato.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),

          // Floating bell button (bottom-right)
          Positioned(
            right: 14,
            bottom: 14,
            child: Material(
              elevation: 6,
              color: Colors.white,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onBellTap,
                child: SizedBox(
                  height: 44,
                  width: 44,
                  child: SvgPicture.asset(AppIcons.playIcon),
                ),
              ),
            ),
          ),

          // Positioned(
          //   right: 70,
          //   bottom: 14,
          //   child: Material(
          //     elevation: 6,
          //     color: Colors.white,
          //     shape: const CircleBorder(),
          //     child: InkWell(
          //       customBorder: const CircleBorder(),
          //       onTap: onBellTap,
          //       child: SizedBox(
          //         height: 44,
          //         width: 44,
          //         child: Icon(
          //           Icons.favorite,
          //           color: Colors.redAccent,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
