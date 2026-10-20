import 'package:flutter/material.dart';

class PermissionHeader extends StatelessWidget {
  const PermissionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFF123966),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.shield, size: 19, color: Colors.white),
        ),
        const SizedBox(width: 9),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SIKAP Intelligence',
                style: TextStyle(
                  color: Color(0xFF172033),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Konfigurasi Pengawal\nDemokrasi',
                style: TextStyle(
                  color: Color(0xFF484E58),
                  fontSize: 12,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF9CEFF1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Text(
            'Langkah 3 dari 3',
            style: TextStyle(
              color: Color(0xFF075F69),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
