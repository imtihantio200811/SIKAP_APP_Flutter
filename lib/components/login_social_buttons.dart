import 'package:flutter/material.dart';

class LoginSocialButtons extends StatelessWidget {
  const LoginSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _DividerLabel(),
        SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: _SocialButton(icon: _SocialIcon.google, label: 'Google'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _SocialButton(icon: _SocialIcon.tiktok, label: 'TikTok'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _SocialButton(icon: _SocialIcon.x, label: 'X (Twitter)'),
            ),
          ],
        ),
      ],
    );
  }
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFE7EBF6), thickness: 1.2)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Atau masuk dengan',
            style: TextStyle(
              color: Color(0xFF737986),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Color(0xFFE7EBF6), thickness: 1.2)),
      ],
    );
  }
}

enum _SocialIcon { google, tiktok, x }

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.label});

  final _SocialIcon icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFF1F2FF),
          foregroundColor: const Color(0xFF152137),
          minimumSize: const Size(0, 60),
          maximumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20, child: Center(child: _SocialGlyph(icon))),
            const SizedBox(height: 4),
            Text(label, maxLines: 1, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _SocialGlyph extends StatelessWidget {
  const _SocialGlyph(this.icon);

  final _SocialIcon icon;

  @override
  Widget build(BuildContext context) {
    return switch (icon) {
      _SocialIcon.google => const Text(
        'G',
        style: TextStyle(
          fontSize: 20,
          height: 1,
          fontWeight: FontWeight.w800,
          color: Color(0xFF4285F4),
        ),
      ),
      _SocialIcon.tiktok => const Icon(Icons.music_note, size: 19),
      _SocialIcon.x => const Text(
        '𝕏',
        style: TextStyle(fontSize: 18, height: 1, fontWeight: FontWeight.w500),
      ),
    };
  }
}
