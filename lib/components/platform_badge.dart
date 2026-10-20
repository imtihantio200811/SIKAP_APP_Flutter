import 'package:flutter/material.dart';

class PlatformBadge extends StatelessWidget {
  const PlatformBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF9CEFF1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_user_outlined,
            size: 12,
            color: Color(0xFF087983),
          ),
          SizedBox(width: 4),
          Text(
            'Platform Pendeteksi HAKS',
            style: TextStyle(
              color: Color(0xFF075F69),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
