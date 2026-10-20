import 'package:flutter/material.dart';

import 'permission_dialog_controls.dart';
import 'permission_dialog_features.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({
    super.key,
    required this.animation,
    required this.overlayEnabled,
    required this.onToggleOverlay,
    required this.onOpenSettings,
    required this.onLater,
  });

  final Listenable animation;
  final bool Function() overlayEnabled;
  final VoidCallback onToggleOverlay;
  final VoidCallback onOpenSettings;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    final maximumHeight = MediaQuery.sizeOf(context).height * 0.96;
    return Center(
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maximumHeight),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, _) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(23, 22, 23, 23),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const PermissionSystemIcon(),
                  const SizedBox(height: 7),
                  const Text(
                    'IZIN SISTEM ANDROID',
                    style: TextStyle(
                      color: Color(0xFF07838A),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Izinkan SIKAP Tampil di Atas\nAplikasi Lain?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF182033),
                      fontSize: 20,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.25,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const PermissionCodeBadge(),
                  const SizedBox(height: 16),
                  const PermissionFeature(
                    icon: Icons.play_circle_outline,
                    title: 'Deteksi Instan TikTok & Reels',
                    description:
                        'Membaca transkrip dan konteks narasi politik saat '
                        'Anda menonton video kampanye secara real-time.',
                    iconColor: Color(0xFF123966),
                    iconBackground: Color(0xFFDDE7FF),
                  ),
                  const SizedBox(height: 9),
                  const PermissionFeature(
                    icon: Icons.touch_app_outlined,
                    title: 'Widget Mengambang 1-\nSentuhan',
                    description:
                        'Gelembung mini aktif yang siap dibuka dengan cepat '
                        'tanpa harus menutup aplikasi sosial media Anda.',
                    iconColor: Color(0xFF087B83),
                    iconBackground: Color(0xFF9CEFF1),
                  ),
                  const SizedBox(height: 9),
                  const PermissionFeature(
                    icon: Icons.verified_user,
                    title: 'Privasi Terjamin',
                    description:
                        'SIKAP tidak pernah merekam data pribadi, ketikan '
                        'tombol, pesan chat, atau sandi perbankan Anda.',
                    iconColor: Color(0xFF087B83),
                    iconBackground: Color(0xFFDDE7FF),
                    tag: 'Audit Terbuka',
                  ),
                  const SizedBox(height: 20),
                  OverlayPermissionRow(
                    value: overlayEnabled(),
                    onChanged: onToggleOverlay,
                  ),
                  const SizedBox(height: 17),
                  const PermissionPrivacyNote(),
                  const SizedBox(height: 15),
                  _SettingsButton(onPressed: onOpenSettings),
                  const SizedBox(height: 8),
                  _LaterButton(onPressed: onLater),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.open_in_new, size: 17),
        label: const Text('Buka Pengaturan Sistem'),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF123966),
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _LaterButton extends StatelessWidget {
  const _LaterButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFE7EDF2),
          foregroundColor: const Color(0xFF484E58),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        child: const Text('Nanti Saja'),
      ),
    );
  }
}
