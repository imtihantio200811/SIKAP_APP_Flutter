import 'package:flutter/material.dart';

class PermissionSystemIcon extends StatelessWidget {
  const PermissionSystemIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 68,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFE5E9FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.policy_outlined,
              color: Color(0xFF123966),
              size: 32,
            ),
          ),
          Positioned(
            right: -3,
            bottom: 0,
            child: Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                color: Color(0xFF007F84),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PermissionCodeBadge extends StatelessWidget {
  const PermissionCodeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.picture_in_picture_alt,
            size: 12,
            color: Color(0xFF485264),
          ),
          SizedBox(width: 5),
          Text(
            'SYSTEM_ALERT_WINDOW',
            style: TextStyle(
              color: Color(0xFF485264),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class PermissionFeature extends StatelessWidget {
  const PermissionFeature({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.iconBackground,
    this.tag,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final Color iconBackground;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(9, 9, 10, 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1FF),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 2,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF1A2132),
                        fontSize: 15,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (tag != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9CEFF1),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          tag!,
                          style: const TextStyle(
                            color: Color(0xFF075F69),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF606671),
                    fontSize: 12,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
