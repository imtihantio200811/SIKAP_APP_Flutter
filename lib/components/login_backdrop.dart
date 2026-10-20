import 'package:flutter/material.dart';

class LoginBackdrop extends StatelessWidget {
  const LoginBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BackdropPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paleBlue = Paint()..color = const Color(0xFFE2EDF6);
    final topWave = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.065)
      ..cubicTo(
        size.width * 0.88,
        size.height * 0.24,
        size.width * 0.74,
        size.height * 0.285,
        size.width * 0.5,
        size.height * 0.285,
      )
      ..cubicTo(
        size.width * 0.27,
        size.height * 0.285,
        size.width * 0.09,
        size.height * 0.19,
        0,
        size.height * 0.095,
      )
      ..close();
    canvas.drawPath(topWave, paleBlue);

    final leftPanel = Path()
      ..moveTo(0, size.height * 0.57)
      ..lineTo(size.width * 0.035, size.height * 0.575)
      ..lineTo(size.width * 0.035, size.height * 0.63)
      ..lineTo(0, size.height * 0.625)
      ..close();
    canvas.drawPath(leftPanel, Paint()..color = const Color(0xFFEAF1F6));
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.965,
        size.height * 0.295,
        size.width * 0.035,
        0.17 * size.height,
      ),
      Paint()..color = const Color(0xFFEAF1F6),
    );
    canvas.drawCircle(
      Offset(size.width * 0.93, size.height * 0.89),
      size.width * 0.18,
      Paint()..color = const Color(0xFFEAF1F6),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
