import 'package:flutter/material.dart';

class PermissionAlgorithmCard extends StatelessWidget {
  const PermissionAlgorithmCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 15, color: Color(0xFF123966)),
              SizedBox(width: 8),
              Text(
                'ALGORITMA AI TERVERIFIKASI',
                style: TextStyle(
                  color: Color(0xFF173354),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          Text(
            'Model SIKAP v2.4 memverifikasi 34.000 klaim pilkada '
            'dan data kebijakan negara secara mandiri dan transparan.',
            style: TextStyle(
              color: Color(0xFF555B66),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
