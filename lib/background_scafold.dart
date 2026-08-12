// lib/widgets/background_scaffold.dart
import 'package:flutter/material.dart';

class BackgroundScaffolds extends StatelessWidget {
  final Widget body;
  final String backgroundImage;
  final bool resizeToAvoidBottomInset;

  // ✅ Added these (only what you need)
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;

  const BackgroundScaffolds({
    super.key,
    required this.body,
    required this.backgroundImage,
    this.resizeToAvoidBottomInset = true,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,

      // ✅ Added support
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,

      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: body,
          ),
        ],
      ),
    );
  }
}
