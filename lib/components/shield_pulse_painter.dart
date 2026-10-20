import 'package:flutter/material.dart';

class ShieldPulsePainter extends CustomPainter {
  const ShieldPulsePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final shield = Path()
      ..moveTo(center.dx, center.dy - 15)
      ..lineTo(center.dx + 11, center.dy - 12)
      ..lineTo(center.dx + 10, center.dy - 1)
      ..cubicTo(
        center.dx + 9,
        center.dy + 7,
        center.dx + 4,
        center.dy + 12,
        center.dx,
        center.dy + 15,
      )
      ..cubicTo(
        center.dx - 4,
        center.dy + 12,
        center.dx - 9,
        center.dy + 7,
        center.dx - 10,
        center.dy - 1,
      )
      ..lineTo(center.dx - 11, center.dy - 12)
      ..close();
    canvas.drawPath(
      shield,
      Paint()
        ..color = const Color(0xFF0D3157)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeJoin = StrokeJoin.round,
    );

    final pulse = Path()
      ..moveTo(center.dx - 16, center.dy - 1)
      ..lineTo(center.dx - 9, center.dy - 1)
      ..lineTo(center.dx - 5, center.dy - 5)
      ..lineTo(center.dx - 1, center.dy + 3)
      ..lineTo(center.dx + 3, center.dy - 5)
      ..lineTo(center.dx + 7, center.dy - 1)
      ..lineTo(center.dx + 16, center.dy - 1);
    canvas.drawPath(
      pulse,
      Paint()
        ..color = const Color(0xFF13A8D8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant ShieldPulsePainter oldDelegate) => false;
}
