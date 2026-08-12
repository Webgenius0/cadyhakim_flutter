import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numynd/assets_helper/app_colors.dart';
import 'package:numynd/assets_helper/app_fonts.dart';
import 'package:numynd/constants/app_constants.dart';
import 'package:numynd/features/favourite_screen/favourite_screen.dart';
import 'package:numynd/features/home_screen/home_screen.dart';
import 'package:numynd/features/profile_screen.dart/profile_screen.dart';
import 'package:numynd/features/setting_screen/setting_screen.dart';
import 'package:numynd/helpers/di.dart';
import 'package:numynd/networks/api_acess.dart';

/// 🔥 GLOBAL CONTROLLER
class BottomNavController {
  static final ValueNotifier<int> index = ValueNotifier<int>(0);
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  /// ✅ Demo flag (replace with your real auth state)
  // bool get isGuest => true; // e.g. AuthService.isGuest / token == null

  @override
  void initState() {
    super.initState();
    getProfileInfoRXObj.getProfileInfoRX();
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomeScreen(key: ValueKey('home'));
      case 1:
        return const FavouriteScreen(key: ValueKey('fav'));
      case 2:
        return const SettingScreen(key: ValueKey('setting'));
      case 3:
        return const ProfileScreen(key: ValueKey('profile'));
      default:
        return const HomeScreen(key: ValueKey('home'));
    }
  }

  void _showLoginRequired() {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('You need to login first'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
  }

  bool get isGuest => !(appData.read(kKeyIsLoggedIn) ?? false);

  void _onBottomNavChanged(int i) {
    if (i == 0) {
      BottomNavController.index.value = i;
      return;
    }

    if (isGuest) {
      setState(() {
        _showLoginRequired();
      });

      return;
    }

    BottomNavController.index.value = i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔥 PAGE AREA
          Positioned.fill(
            child: ValueListenableBuilder<int>(
              valueListenable: BottomNavController.index,
              builder: (_, index, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _buildPage(index),
                );
              },
            ),
          ),

          /// 🔥 BOTTOM BAR
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 16),
              child: ValueListenableBuilder<int>(
                valueListenable: BottomNavController.index,
                builder: (_, index, __) {
                  return GlassBottomBar(
                    index: index,
                    onChanged: _onBottomNavChanged, // ✅ only change here
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===== Bottom Bar (UNCHANGED UI) =====

class GlassBottomBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const GlassBottomBar({
    super.key,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = <_Item>[
      _Item(Icons.home_rounded, 'Home'),
      _Item(Icons.favorite_rounded, 'Favorite'),
      _Item(Icons.settings_rounded, 'Settings'),
      _Item(Icons.person_rounded, 'Profile'),
    ];

    final barWidth = MediaQuery.of(context).size.width - 32;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: barWidth,
            height: 64.h,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0F14).withOpacity(0.35),
              borderRadius: BorderRadius.circular(32.r),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(items.length, (i) {
                final selected = i == index;
                final item = items[i];

                return InkWell(
                  borderRadius: BorderRadius.circular(24.r),
                  onTap: () => onChanged(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: selected ? 14.w : 8.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColor.cEAF3PB : Colors.transparent,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          size: 22.sp,
                          color: selected ? Colors.black87 : Colors.white,
                        ),
                        if (selected) ...[
                          SizedBox(width: 8.w),
                          Text(
                            item.label ?? '',
                            style: TextFontStyle.textStyle12w400Lato.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _Item {
  final IconData icon;
  final String? label;
  _Item(this.icon, this.label);
}
