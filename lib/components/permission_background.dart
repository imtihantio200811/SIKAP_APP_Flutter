import 'package:flutter/material.dart';

class PermissionBackground extends StatelessWidget {
  const PermissionBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PermissionBackgroundPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _PermissionBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final top = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.06)
      ..cubicTo(
        size.width * 0.89,
        size.height * 0.24,
        size.width * 0.70,
        size.height * 0.28,
        size.width * 0.5,
        size.height * 0.28,
      )
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.28,
        size.width * 0.09,
        size.height * 0.19,
        0,
        size.height * 0.08,
      )
      ..close();
    canvas.drawPath(top, Paint()..color = const Color(0xFFE2EDF6));

    final accent = Paint()..color = const Color(0xFFE6EEF5);
    canvas.drawCircle(
      Offset(-size.width * 0.04, size.height * 0.57),
      size.width * 0.22,
      accent,
    );
    canvas.drawCircle(
      Offset(size.width * 1.02, size.height * 0.88),
      size.width * 0.22,
      accent,
    );
    canvas.drawCircle(
      Offset(size.width, size.height * 0.38),
      size.width * 0.20,
      Paint()..color = const Color(0xFFEAF1F7),
    );
  }

  @override
  bool shouldRepaint(covariant _PermissionBackgroundPainter oldDelegate) =>
      false;
}
