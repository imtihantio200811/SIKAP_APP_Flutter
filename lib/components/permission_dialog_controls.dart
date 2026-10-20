import 'package:flutter/material.dart';

class OverlayPermissionRow extends StatelessWidget {
  const OverlayPermissionRow({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EBFF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.settings_suggest,
            size: 19,
            color: Color(0xFF123966),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Izinkan Menampilkan di Atas',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF1A2132),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Pratinjau sakelar Android',
                  style: TextStyle(color: Color(0xFF606671), fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          _DialogSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _DialogSwitch extends StatelessWidget {
  const _DialogSwitch({required this.value, required this.onChanged});

  final bool value;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 56,
        height: 32,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? const Color(0xFF06274B) : const Color(0xFFAAB3C0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              value ? Icons.check : Icons.close,
              size: 16,
              color: const Color(0xFF123966),
            ),
          ),
        ),
      ),
    );
  }
}

class PermissionPrivacyNote extends StatelessWidget {
  const PermissionPrivacyNote({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      children: [
        Icon(Icons.lock_outline, size: 13, color: Color(0xFF07838A)),
        Text(
          'Enkripsi Berkas Lokal • Zero Log Identity',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF747984),
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
