import 'package:flutter/material.dart';

class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OnboardingBackgroundPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _OnboardingBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF4F8FB),
    );

    final lowerWave = Path()
      ..moveTo(0, size.height * 0.49)
      ..cubicTo(
        size.width * 0.24,
        size.height * 0.48,
        size.width * 0.33,
        size.height * 0.51,
        size.width * 0.53,
        size.height * 0.51,
      )
      ..cubicTo(
        size.width * 0.76,
        size.height * 0.51,
        size.width * 0.88,
        size.height * 0.49,
        size.width,
        size.height * 0.50,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(lowerWave, Paint()..color = Colors.white);

    final accentPaint = Paint()..color = const Color(0xFFE5EEF6);
    canvas.drawCircle(
      Offset(-size.width * 0.07, size.height * 0.58),
      size.width * 0.25,
      accentPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 1.04, size.height * 0.90),
      size.width * 0.22,
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _OnboardingBackgroundPainter oldDelegate) =>
      false;
}
