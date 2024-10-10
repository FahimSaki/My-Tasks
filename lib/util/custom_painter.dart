// blurred_circle_painter.dart

import 'package:flutter/material.dart';

class BlurredCirclePainter extends CustomPainter {
  final double blurRadius;

  BlurredCirclePainter({required this.blurRadius});

  @override
  void paint(Canvas canvas, Size size) {
    // Create a paint object with blur
    Paint paint = Paint()
      ..color =
          Colors.black.withOpacity(0.3) // Set desired opacity for the blur
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

    // Draw a blurred circle centered at the same point as the checkbox
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is BlurredCirclePainter &&
        oldDelegate.blurRadius != blurRadius;
  }
}
