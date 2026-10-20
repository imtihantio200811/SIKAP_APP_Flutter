import 'package:flutter/material.dart';

class CitizenProfileImpact extends StatelessWidget {
  const CitizenProfileImpact({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Text(
                'Dampak Demokrasi Digital',
                style: TextStyle(
                  color: Color(0xFF18253B),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              'Bulan Ini',
              style: TextStyle(
                color: Color(0xFF007985),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Expanded(
              child: _ImpactCard(
                icon: Icons.find_in_page_outlined,
                iconColor: Color(0xFF143A62),
                iconBackground: Color(0xFFD9E3FF),
                value: '42',
                valueColor: Color(0xFF0A2C50),
                label: 'Total Diperiksa',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _ImpactCard(
                icon: Icons.shield_outlined,
                iconColor: Color(0xFFC31E24),
                iconBackground: Color(0xFFFFD9D6),
                value: '29',
                valueColor: Color(0xFFC51A20),
                label: 'Hoaks\nTerhindar',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _ImpactCard(
                icon: Icons.group_add_outlined,
                iconColor: Color(0xFF007A83),
                iconBackground: Color(0xFF9CEFF1),
                value: '1.4k',
                valueColor: Color(0xFF007A83),
                label: 'Warga\nTerbantu',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.value,
    required this.valueColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String value;
  final Color valueColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 122,
      padding: const EdgeInsets.fromLTRB(5, 11, 5, 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x090E3155),
            blurRadius: 7,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 20,
              height: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF505763),
              fontSize: 11,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
