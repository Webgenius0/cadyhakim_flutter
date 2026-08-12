import 'dart:math';
import 'package:flutter/material.dart';

/// ======================
/// Path Generator Function
/// ======================
Path buildRoundedStarPath(
  Size size, {
  int lobes = 8,
  double innerRatio = 0.70,
  double curve = 0.28,
  double boost = 1.35,
}) {
  final cx = size.width / 2;
  final cy = size.height / 2;
  final outerR = min(cx, cy);
  final innerR = (outerR * innerRatio).clamp(0.0, outerR - 1);
  final n = max(3, lobes);

  const double startAngle = -pi / 2;
  final path = Path();

  Offset pointAt(bool outer, int i) {
    final r = outer ? outerR : innerR;
    final t = startAngle + (i * pi / n);
    return Offset(cx + r * cos(t), cy + r * sin(t));
  }

  // প্রথম পয়েন্ট
  final p0 = pointAt(true, 0);
  path.moveTo(p0.dx, p0.dy);

  // curve সহ বাকি সব পয়েন্ট
  for (int i = 1; i <= n * 2; i++) {
    final isOuter = i.isEven;
    final p1 = pointAt(isOuter, i);
    final pPrev = pointAt(!isOuter, i - 1);
    final mid = Offset((pPrev.dx + p1.dx) / 2, (pPrev.dy + p1.dy) / 2);

    // কেন্দ্র থেকে বাইরে ঠেলে curve বানানো
    final dx = mid.dx - cx;
    final dy = mid.dy - cy;
    final ctrl = Offset(
      mid.dx + boost * curve * dx,
      mid.dy + boost * curve * dy,
    );

    path.quadraticBezierTo(ctrl.dx, ctrl.dy, p1.dx, p1.dy);
  }

  path.close();
  return path;
}

/// ======================
/// Custom Painter
/// ======================
class FlowerPainter extends CustomPainter {
  final int lobes;
  final double innerRatio;
  final double curve;
  final double boost;
  final Color strokeColor;
  final double strokeWidth;
  final double shadowBlur;
  final Color shadowColor;

  FlowerPainter({
    this.lobes = 8,
    this.innerRatio = 0.70,
    this.curve = 0.28,
    this.boost = 1.35,
    this.strokeColor = const Color(0x22000000),
    this.strokeWidth = 1.2,
    this.shadowBlur = 12,
    this.shadowColor = const Color(0x22000000),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = buildRoundedStarPath(size,
        lobes: lobes, innerRatio: innerRatio, curve: curve, boost: boost);

    // Shadow
    final shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);
    canvas.drawPath(path, shadowPaint);

    // Stroke
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant FlowerPainter old) {
    return old.lobes != lobes ||
        old.innerRatio != innerRatio ||
        old.curve != curve ||
        old.boost != boost;
  }
}

/// ======================
/// Clipper for Image
/// ======================
class _FlowerClipper extends CustomClipper<Path> {
  final int lobes;
  final double innerRatio;
  final double curve;
  final double boost;

  _FlowerClipper({
    required this.lobes,
    required this.innerRatio,
    required this.curve,
    required this.boost,
  });

  @override
  Path getClip(Size size) => buildRoundedStarPath(size,
      lobes: lobes, innerRatio: innerRatio, curve: curve, boost: boost);

  @override
  bool shouldReclip(covariant _FlowerClipper old) =>
      old.lobes != lobes ||
      old.innerRatio != innerRatio ||
      old.curve != curve ||
      old.boost != boost;
}

/// ======================
/// Main Widget
/// ======================
class PaintedFlowerImage extends StatelessWidget {
  final double size;
  final String assetImage;
  final int lobes;
  final double innerRatio;
  final double curve;
  final double boost;

  const PaintedFlowerImage({
    super.key,
    required this.size,
    required this.assetImage,
    this.lobes = 8,
    this.innerRatio = 0.70,
    this.curve = 0.28,
    this.boost = 1.35,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Shadow + stroke paint
          CustomPaint(
            painter: FlowerPainter(
              lobes: lobes,
              innerRatio: innerRatio,
              curve: curve,
              boost: boost,
            ),
          ),
          // Image clipped to same path
          ClipPath(
            clipper: _FlowerClipper(
              lobes: lobes,
              innerRatio: innerRatio,
              curve: curve,
              boost: boost,
            ),
            child: Image.network(
              assetImage,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
