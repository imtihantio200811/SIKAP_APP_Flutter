import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 61,
      width: double.infinity,
      child: CustomPaint(
        painter: _HeaderPatternPainter(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 27, 8),
          child: Row(
            children: [
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF78B9D4), width: 2),
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: Color(0xFF123966),
                  size: 21,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIKAP',
                      style: TextStyle(
                        color: Color(0xFF102B47),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Profil Warga',
                      style: TextStyle(
                        color: Color(0xFF14243A),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 24,
                  ),
                  Positioned(
                    top: -1,
                    right: -1,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD90016),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF56758A),
    );
    final line = Paint()
      ..color = const Color(0xFF82B8D1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final pale = Paint()..color = const Color(0xFFB7D8E8);
    final centers = <Offset>[
      const Offset(17, 7),
      const Offset(92, 32),
      const Offset(165, 2),
      const Offset(202, 44),
      const Offset(257, 23),
      const Offset(330, 7),
      const Offset(382, 40),
    ];
    for (final center in centers) {
      canvas.drawCircle(center, 12, line);
      canvas.drawCircle(center, 7, pale);
      canvas.drawCircle(center, 3, Paint()..color = const Color(0xFF52758C));
      final diamond = Path()
        ..moveTo(center.dx, center.dy - 17)
        ..lineTo(center.dx + 6, center.dy - 11)
        ..lineTo(center.dx, center.dy - 5)
        ..lineTo(center.dx - 6, center.dy - 11)
        ..close();
      canvas.drawPath(diamond, line);
      canvas.drawCircle(
        center.translate(21, 10),
        2,
        Paint()..color = const Color(0xFFDDEAF0),
      );
      canvas.drawCircle(
        center.translate(-20, 15),
        1.7,
        Paint()..color = const Color(0xFFDDEAF0),
      );
    }
    for (var x = 0.0; x < size.width; x += 25) {
      canvas.drawCircle(
        Offset(x, 55),
        1.4,
        Paint()..color = const Color(0xFFDDEAF0),
      );
      canvas.drawCircle(
        Offset(x + 12, 9),
        1.2,
        Paint()..color = const Color(0xFFDDEAF0),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HeaderPatternPainter oldDelegate) => false;
}
