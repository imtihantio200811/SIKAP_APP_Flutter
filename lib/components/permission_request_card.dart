import 'package:flutter/material.dart';

class PermissionRequestCard extends StatelessWidget {
  const PermissionRequestCard({
    super.key,
    required this.realTimeScanningEnabled,
    required this.onToggleRealTimeScanning,
    required this.onRequestAccess,
    required this.onLater,
  });

  final bool realTimeScanningEnabled;
  final VoidCallback onToggleRealTimeScanning;
  final VoidCallback onRequestAccess;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFC9CDD4)),
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A17263A),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconCircle(
                icon: Icons.desktop_windows_outlined,
                size: 40,
                background: Color(0xFF123966),
                foreground: Colors.white,
              ),
              const SizedBox(width: 9),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Izin Hamparan Layar',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF12345A),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Android System Permission',
                      style: TextStyle(color: Color(0xFF535963), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          const Text.rich(
            TextSpan(
              style: TextStyle(
                color: Color(0xFF192338),
                fontSize: 14,
                height: 1.55,
              ),
              children: [
                TextSpan(text: 'SIKAP membutuhkan izin '),
                TextSpan(
                  text: 'Tampilkan di Atas Aplikasi Lain',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      ' untuk mendeteksi informasi hoaks dan disinformasi '
                      'pilkada secara langsung saat Anda membaca berita atau '
                      'media sosial.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            constraints: const BoxConstraints(minHeight: 50),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1FF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  color: Color(0xFF092E55),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aktifkan Pemindaian Real-Time',
                        style: TextStyle(
                          color: Color(0xFF182033),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Data diproses lokal di perangkat',
                        style: TextStyle(
                          color: Color(0xFF626873),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                _PermissionSwitch(
                  value: realTimeScanningEnabled,
                  onChanged: onToggleRealTimeScanning,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 41,
            child: FilledButton.icon(
              onPressed: onRequestAccess,
              icon: const Icon(Icons.settings, size: 17),
              label: const Text('Izinkan Akses Layar'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF06274B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: TextButton(
              onPressed: onLater,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFE4E9EE),
                foregroundColor: const Color(0xFF484E58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('Nanti Saja'),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({
    required this.icon,
    required this.size,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final double size;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, size: 20, color: foreground),
    );
  }
}

class _PermissionSwitch extends StatelessWidget {
  const _PermissionSwitch({required this.value, required this.onChanged});

  final bool value;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 48,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? const Color(0xFF06274B) : const Color(0xFFACB4C0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              value ? Icons.check : Icons.close,
              size: 13,
              color: const Color(0xFF123966),
            ),
          ),
        ),
      ),
    );
  }
}
