import 'package:flutter/material.dart';

import '../controllers/citizen_profile_controller.dart';
import 'citizen_profile_impact.dart';
import 'citizen_profile_summary.dart';
import 'floating_widget_settings.dart';

class CitizenProfileContent extends StatelessWidget {
  const CitizenProfileContent({
    super.key,
    required this.controller,
    required this.onLogout,
  });

  final CitizenProfileController controller;
  final VoidCallback onLogout;

  void _showProfileSettings(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengaturan Profil'),
        content: const Text(
          'Kelola profil warga dan preferensi keamanan akun Anda.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 27, 17, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profil Warga Digital',
                      style: TextStyle(
                        color: Color(0xFF0A2C50),
                        fontSize: 20,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.35,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Integritas Ruang Siber & Advokasi Publik',
                      style: TextStyle(color: Color(0xFF505763), fontSize: 12),
                    ),
                  ],
                ),
              ),
              Material(
                color: const Color(0xFFE6ECFF),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => _showProfileSettings(context),
                  child: const SizedBox(
                    width: 42,
                    height: 42,
                    child: Icon(
                      Icons.settings,
                      color: Color(0xFF0B3157),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 21),
          const CitizenProfileSummary(),
          const SizedBox(height: 22),
          const CitizenProfileImpact(),
          const SizedBox(height: 22),
          FloatingWidgetSettings(
            floatingWidgetEnabled: controller.floatingWidgetEnabled,
            earlyWarningEnabled: controller.earlyWarningEnabled,
            sensitivity: controller.sensitivity,
            onToggleFloatingWidget: controller.toggleFloatingWidget,
            onToggleEarlyWarning: controller.toggleEarlyWarning,
            onCycleSensitivity: controller.cycleSensitivity,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
            ),
          ),
        ],
      ),
    );
  }
}
