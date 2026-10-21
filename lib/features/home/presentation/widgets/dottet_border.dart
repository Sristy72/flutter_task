import 'dart:math' as math;

import 'package:flutter/material.dart';

class DottedCirclePainter extends CustomPainter {
  final Color color;

  const DottedCirclePainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - .8;

    const int dotCount = 24;
    const double dotAngle = 0.055;

    for (int i = 0; i < dotCount; i++) {
      final double startAngle =
          (2 * math.pi * i) / dotCount;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dotAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DottedCirclePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}