import 'package:flutter/material.dart';

/// A reusable Scaffold wrapper with background image support
/// 
/// This widget provides:
/// - Background image layer
/// - Content area (scaffold area) on top of the background
/// - SafeArea support
/// - Scrollable content support
class BackgroundScaffold extends StatelessWidget {
  /// The background image asset path
  final String? backgroundImage;
  
  /// The content widget to display on top of the background
  final Widget child;
  
  /// Whether to wrap content in SafeArea
  final bool useSafeArea;
  
  /// Whether to make content scrollable
  final bool isScrollable;
  
  /// Padding for the content area
  final EdgeInsets? padding;
  
  /// Background image fit mode
  final BoxFit backgroundFit;
  
  /// Background color (shown behind image if image doesn't cover)
  final Color? backgroundColor;
  
  /// Whether to resize when keyboard appears
  final bool resizeToAvoidBottomInset;
  
  /// AppBar for the scaffold
  final PreferredSizeWidget? appBar;
  
  /// Floating action button
  final Widget? floatingActionButton;
  
  /// Floating action button location
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  
  /// Bottom navigation bar
  final Widget? bottomNavigationBar;
  
  /// Drawer
  final Widget? drawer;
  
  /// End drawer
  final Widget? endDrawer;

  const BackgroundScaffold({
    super.key,
    this.backgroundImage,
    required this.child,
    this.useSafeArea = true,
    this.isScrollable = false,
    this.padding,
    this.backgroundFit = BoxFit.cover,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor ?? Colors.transparent,
      body: Stack(
        children: [
          // Background Image Layer
          if (backgroundImage != null)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage!),
                  fit: backgroundFit,
                ),
              ),
            ),

          // Content Area (Scaffold Area)
          if (useSafeArea)
            SafeArea(
              child: _buildContent(context),
            )
          else
            _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    Widget content = padding != null
        ? Padding(
            padding: padding!,
            child: child,
          )
        : child;

    if (isScrollable) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + (padding?.bottom ?? 0),
        ),
        child: content,
      );
    }

    return content;
  }
}
