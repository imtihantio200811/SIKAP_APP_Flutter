import 'package:flutter/material.dart';

class FloatingScanBubbleLoadingPanel extends StatelessWidget {
  const FloatingScanBubbleLoadingPanel({super.key, this.previewOnly = false});

  final bool previewOnly;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.28),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(height: 16),
              Text(
                previewOnly
                    ? 'Menyiapkan jendela hasil...'
                    : 'Memeriksa konten...',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                previewOnly
                    ? 'Pemindaian berita belum dimulai'
                    : 'SIKAP sedang menilai klaim dan sumbernya',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Color(0xFF657287)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
