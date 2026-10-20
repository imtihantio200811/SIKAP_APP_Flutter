import 'package:flutter/material.dart';

class OnboardingDescription extends StatelessWidget {
  const OnboardingDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF9CEFF1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.smart_toy_outlined,
                size: 13,
                color: Color(0xFF087983),
              ),
              SizedBox(width: 5),
              Text(
                'MULTI-PLATFORM GUARD',
                style: TextStyle(
                  color: Color(0xFF075F69),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Deteksi Hoaks Otomatis\nSaat Nonton Video',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF171D2C),
            fontSize: 26,
            height: 1.25,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.25,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Aktifkan gelombang pintar SIKAP saat scrolling\n'
          'TikTok, YouTube Shorts, atau Reels. AI akan\n'
          'membaca teks dan audio secara instan tanpa\n'
          'perlu beralih aplikasi.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF4E535C),
            fontSize: 15,
            height: 1.55,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
