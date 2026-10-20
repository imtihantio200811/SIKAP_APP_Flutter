import 'package:flutter/material.dart';

class OnboardingStepHeader extends StatelessWidget {
  const OnboardingStepHeader({super.key, required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E9FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 6, color: Color(0xFF078B8D)),
                SizedBox(width: 6),
                Text(
                  'LANGKAH 2 DARI 3',
                  style: TextStyle(
                    color: Color(0xFF142B48),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: const Color(0xFF747984),
            ),
            child: const Text(
              'Lewati',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
