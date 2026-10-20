import 'package:flutter/material.dart';

/// Custom painter to render the subtle starry background dots exactly as in Figma.



class DotBackgroundPainter extends CustomPainter {
  const DotBackgroundPainter();

  // Exact relative dot coordinates (xRatio, yRatio, radius, opacity) matching Figma
  static const List<_DotSpec> _dots = [
    _DotSpec(0.148, 0.106, 1.6, 0.85), // Top left dot
    _DotSpec(0.643, 0.085, 1.1, 0.50), // Top right dot
    _DotSpec(0.835, 0.208, 1.2, 0.45), // Mid right dot
    _DotSpec(0.380, 0.363, 1.4, 0.75), // Next to moon icon
    _DotSpec(0.062, 0.672, 1.5, 0.90), // Mid-lower left dot
    _DotSpec(0.248, 0.725, 1.1, 0.45), // Lower left dot
    _DotSpec(0.592, 0.745, 1.3, 0.65), // Lower center dot
    _DotSpec(0.870, 0.766, 1.0, 0.40), // Far lower right dot
    _DotSpec(0.771, 0.828, 1.1, 0.50), // Lower right dot
    _DotSpec(0.201, 0.878, 1.5, 0.85), // Bottom left dot
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final dot in _dots) {
      final paint = Paint()
        ..color = Color.fromRGBO(255, 255, 255, dot.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(dot.xRatio * size.width, dot.yRatio * size.height),
        dot.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DotSpec {
  final double xRatio;
  final double yRatio;
  final double radius;
  final double opacity;

  const _DotSpec(this.xRatio, this.yRatio, this.radius, this.opacity);
}