import 'package:flutter/material.dart';

class VerificationFooter extends StatelessWidget {
  const VerificationFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_outlined,
              size: 16,
              color: Color(0xFF07868A),
            ),
            SizedBox(width: 6),
            Text(
              'KONSORSIUM VERIFIKASI PUBLIK',
              style: TextStyle(
                color: Color(0xFF087A82),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Terintegrasi dengan data KPU, Bawaslu, & Koalisi\n'
          'Cek Fakta Independen untuk validasi rekam jejak\n'
          'tanpa bias.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF858A94),
            fontSize: 13,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 11,
          children: const [
            _PartnerBadge(icon: Icons.person_outline, label: 'KPU'),
            Text('•', style: TextStyle(color: Color(0xFF747984))),
            _PartnerBadge(icon: Icons.shield_outlined, label: 'Bawaslu'),
            Text('•', style: TextStyle(color: Color(0xFF747984))),
            _PartnerBadge(icon: Icons.fact_check_outlined, label: 'MaInfo'),
          ],
        ),
      ],
    );
  }
}

class _PartnerBadge extends StatelessWidget {
  const _PartnerBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF168B91)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF666D77), fontSize: 12),
        ),
      ],
    );
  }
}
