import 'package:flutter/material.dart';

class FloatingWidgetSettings extends StatelessWidget {
  const FloatingWidgetSettings({
    super.key,
    required this.floatingWidgetEnabled,
    required this.earlyWarningEnabled,
    required this.sensitivity,
    required this.onToggleFloatingWidget,
    required this.onToggleEarlyWarning,
    required this.onCycleSensitivity,
  });

  final bool floatingWidgetEnabled;
  final bool earlyWarningEnabled;
  final String sensitivity;
  final VoidCallback onToggleFloatingWidget;
  final VoidCallback onToggleEarlyWarning;
  final VoidCallback onCycleSensitivity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.dashboard_customize_outlined,
              color: Color(0xFF143A62),
              size: 17,
            ),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'Pengaturan Floating Widget',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFF18253B),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _SettingRow(
          title: 'Gelembung Pemindai Otomatis',
          description: 'Tampilkan saat membuka TikTok, IG Reels, & Shorts',
          trailing: _ProfileSwitch(
            value: floatingWidgetEnabled,
            onChanged: onToggleFloatingWidget,
          ),
        ),
        const Divider(height: 16, color: Color(0xFFDDE5FF)),
        _SettingRow(
          title: 'Sensitivitas AI Verifikasi',
          description: 'Ambang deteksi narasi manipulatif dan klaim provokatif',
          trailing: _SensitivityButton(
            value: sensitivity,
            onTap: onCycleSensitivity,
          ),
        ),
        const Divider(height: 16, color: Color(0xFFDDE5FF)),
        _SettingRow(
          title: 'Pemberitahuan Peringatan Dini',
          description: 'Peringatan real-time hoaks berpotensi viral',
          trailing: _ProfileSwitch(
            value: earlyWarningEnabled,
            onChanged: onToggleEarlyWarning,
          ),
        ),
        const Divider(height: 16, color: Color(0xFFDDE5FF)),
        _SettingRow(
          title: 'Privasi Aktivitas',
          description: 'Kelola visibilitas kontribusi profil Anda',
          trailing: const Icon(
            Icons.chevron_right,
            color: Color(0xFF18395C),
            size: 22,
          ),
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.title,
    required this.description,
    required this.trailing,
  });

  final String title;
  final String description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF18253B),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF505763),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }
}

class _ProfileSwitch extends StatelessWidget {
  const _ProfileSwitch({required this.value, required this.onChanged});

  final bool value;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Toggle',
      value: value ? 'Aktif' : 'Nonaktif',
      button: true,
      child: GestureDetector(
        onTap: onChanged,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 48,
          height: 24,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: value ? const Color(0xFF123966) : const Color(0xFFBCC5D1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 160),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SensitivityButton extends StatelessWidget {
  const _SensitivityButton({required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE4E9FF),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF19395C),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF19395C),
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
