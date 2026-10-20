import 'package:flutter/material.dart';

class ForensicPreview extends StatelessWidget {
  const ForensicPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF082442),
        borderRadius: BorderRadius.circular(11),
      ),
      child: CustomPaint(
        painter: _ForensicPreviewPainter(),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'AUDIO FORENSIK  •  VISUALISASI SPEKTRUM',
              style: TextStyle(
                color: Color(0xFFB7E5F5),
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.35,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForensicPreviewPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B3457), Color(0xFF071B35)],
        ).createShader(bounds),
    );
    final grid = Paint()
      ..color = const Color(0xFF316387).withValues(alpha: 0.45)
      ..strokeWidth = 0.7;
    for (var x = 0.0; x < size.width; x += 18) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var y = 22.0; y < size.height; y += 18) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    for (var x = 12.0; x < size.width; x += 7) {
      final intensity = (x * 0.7).round() % 27;
      final height = 18.0 + intensity * 1.9;
      final paint = Paint()
        ..color = x > size.width * 0.65
            ? const Color(0xFFE4454C).withValues(alpha: 0.7)
            : const Color(0xFF36B8D8).withValues(alpha: 0.65);
      canvas.drawRect(
        Rect.fromLTWH(x, size.height - height, 3.5, height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ForensicPreviewPainter oldDelegate) => false;
}
