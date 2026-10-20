import 'package:flutter/material.dart';

class PermissionModes extends StatelessWidget {
  const PermissionModes({
    super.key,
    required this.dynamicScreenSelected,
    required this.onSelect,
  });

  final bool dynamicScreenSelected;
  final ValueChanged<bool> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _PermissionMode(
          icon: Icons.notifications_active_outlined,
          title: 'Notifikasi Verifikasi Cepat',
          subtitle: 'Peringatan real-time hoaks viral',
          iconBackground: Color(0xFFE6E9FF),
          iconColor: Color(0xFF087A82),
          selected: true,
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => onSelect(!dynamicScreenSelected),
          child: _PermissionMode(
            icon: Icons.layers_outlined,
            title: 'Hamparan Layar Dinamis',
            subtitle: 'Deteksi instan di feed medsos',
            iconBackground: const Color(0xFFD8E6FF),
            iconColor: const Color(0xFF123966),
            selected: dynamicScreenSelected,
          ),
        ),
      ],
    );
  }
}

class _PermissionMode extends StatelessWidget {
  const _PermissionMode({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBackground,
    required this.iconColor,
    required this.selected,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconBackground;
  final Color iconColor;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF182033),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF626873),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            selected ? Icons.check_circle : Icons.radio_button_checked,
            color: selected ? const Color(0xFF007B80) : const Color(0xFF062A4E),
            size: 21,
          ),
        ],
      ),
    );
  }
}
