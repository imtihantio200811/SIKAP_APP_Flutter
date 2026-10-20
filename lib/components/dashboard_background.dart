import 'package:flutter/material.dart';

class DashboardBackground extends StatelessWidget {
  const DashboardBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashboardBackgroundPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _DashboardBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF7FAFC),
    );
    final blue = Paint()..color = const Color(0xFFE4EEF6);
    final top = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.075)
      ..cubicTo(
        size.width * 0.85,
        size.height * 0.22,
        size.width * 0.72,
        size.height * 0.25,
        size.width * 0.5,
        size.height * 0.25,
      )
      ..cubicTo(
        size.width * 0.27,
        size.height * 0.25,
        size.width * 0.1,
        size.height * 0.18,
        0,
        size.height * 0.08,
      )
      ..close();
    canvas.drawPath(top, blue);
    canvas.drawCircle(
      Offset(size.width * 1.03, size.height * 0.44),
      size.width * 0.2,
      blue,
    );
    canvas.drawCircle(
      Offset(-size.width * 0.06, size.height * 0.58),
      size.width * 0.23,
      Paint()..color = const Color(0xFFEAF1F7),
    );
    canvas.drawCircle(
      Offset(size.width * 1.04, size.height * 0.88),
      size.width * 0.22,
      Paint()..color = const Color(0xFFE5EEF6),
    );
  }

  @override
  bool shouldRepaint(covariant _DashboardBackgroundPainter oldDelegate) =>
      false;
}
