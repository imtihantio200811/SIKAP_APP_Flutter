import 'package:flutter/material.dart';

import 'forensic_preview.dart';

class VerifiedClaimCard extends StatelessWidget {
  const VerifiedClaimCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 10, 10, 9),
            decoration: const BoxDecoration(
              color: Color(0xFFC51A20),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.gpp_maybe, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'HOAKS TERDETEKSI / MANIPULASI DEEPFAKE',
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x40FFFFFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Bahaya Tinggi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ClaimSourceRow(),
                const SizedBox(height: 9),
                const Text(
                  '“Klaim: Rekaman Rahasia\n'
                  'Percakapan Ketum Partai Mengenai\n'
                  'Pengkondisian Suara Pemilu 2024”',
                  style: TextStyle(
                    color: Color(0xFF0A2C50),
                    fontSize: 17,
                    height: 1.42,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 17),
                const _ConfidencePanel(),
                const SizedBox(height: 12),
                const ForensicPreview(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClaimSourceRow extends StatelessWidget {
  const _ClaimSourceRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.smart_display_outlined, size: 14, color: Color(0xFF123966)),
        SizedBox(width: 4),
        Text(
          'TikTok',
          style: TextStyle(
            color: Color(0xFF183252),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 7),
        Text('•', style: TextStyle(color: Color(0xFF535965))),
        SizedBox(width: 7),
        Expanded(
          child: Text(
            'Diunggah 4 jam lalu',
            style: TextStyle(
              color: Color(0xFF535965),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Icon(Icons.visibility_outlined, size: 13, color: Color(0xFF515965)),
        SizedBox(width: 3),
        Text(
          '840K',
          style: TextStyle(
            color: Color(0xFF414854),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 7),
        Icon(Icons.share_outlined, size: 12, color: Color(0xFF515965)),
        SizedBox(width: 2),
        Text(
          '14.2K',
          style: TextStyle(
            color: Color(0xFF414854),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ConfidencePanel extends StatelessWidget {
  const _ConfidencePanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.speed, color: Color(0xFFD01920), size: 16),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Tingkat Kepercayaan Publik',
                  style: TextStyle(
                    color: Color(0xFF163253),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '14% (Kritis)',
                style: TextStyle(
                  color: Color(0xFFD01920),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 0.14,
              minHeight: 12,
              backgroundColor: Color(0xFFDCE4FF),
              color: Color(0xFFC51A20),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(
                Icons.record_voice_over_outlined,
                size: 15,
                color: Color(0xFF00818A),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'AI Confidence Model:',
                  style: TextStyle(color: Color(0xFF505763), fontSize: 11),
                ),
              ),
              _ConfidenceTag(),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConfidenceTag extends StatelessWidget {
  const _ConfidenceTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFC9F1FB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        '96.4% Analisis Suara Sintetis',
        maxLines: 2,
        style: TextStyle(
          color: Color(0xFF153553),
          fontSize: 10,
          height: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
