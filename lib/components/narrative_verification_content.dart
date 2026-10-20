import 'package:flutter/material.dart';

import '../controllers/narrative_verification_controller.dart';
import 'narrative_verification_form.dart';
import 'verified_claim_card.dart';

class NarrativeVerificationContent extends StatelessWidget {
  const NarrativeVerificationContent({super.key, required this.controller});

  final NarrativeVerificationController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _VerificationIntro(),
          const SizedBox(height: 20),
          NarrativeVerificationForm(
            controller: controller.linkController,
            isAnalyzing: controller.isAnalyzing,
            onPaste: controller.pasteLink,
            onVerify: controller.verifyLink,
            onSelectDemo: (text) => controller.verifyContent(text),
          ),
          const SizedBox(height: 19),
          const _AuditHeading(),
          const SizedBox(height: 18),
          const VerifiedClaimCard(),
          const SizedBox(height: 24),
          _MonitoredNarratives(
            onSelectNarrative: (text) => controller.verifyContent(text),
          ),
        ],
      ),
    );
  }
}

class _MonitoredNarratives extends StatelessWidget {
  const _MonitoredNarratives({this.onSelectNarrative});

  final ValueChanged<String>? onSelectNarrative;

  static const _items = [
    (
      title: 'Kutipan pidato beredar tanpa rekaman lengkap',
      description:
          'Periksa konteks sebelum dan sesudah kutipan serta bandingkan dengan sumber asli.',
      icon: Icons.mic_none,
      color: Color(0xFFB87912),
      status: 'BUTUH KONTEKS',
    ),
    (
      title: 'Video kebijakan lama disebut sebagai pengumuman baru',
      description:
          'Tanggal unggahan awal dan arsip resmi diperlukan untuk memastikan waktu kejadian.',
      icon: Icons.video_library_outlined,
      color: Color(0xFF315D91),
      status: 'DIPANTAU',
    ),
    (
      title: 'Gambar dokumen tersebar tanpa tautan sumber',
      description:
          'Cocokkan nomor dokumen dan isi pernyataan dengan kanal instansi terkait.',
      icon: Icons.description_outlined,
      color: Color(0xFF7555A0),
      status: 'PERLU SUMBER',
    ),
    (
      title: 'Narasi bantuan publik mencampur data lintas periode',
      description:
          'Pastikan angka, tanggal, dan wilayah merujuk pada periode yang sama.',
      icon: Icons.compare_arrows,
      color: Color(0xFF167B69),
      status: 'DIPANTAU',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Narasi dalam Pemantauan',
          style: TextStyle(
            color: Color(0xFF0A2C50),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Contoh isu publik yang memerlukan pemeriksaan konteks dan sumber. '
          'Klik narasi untuk langsung menganalisis.',
          style: TextStyle(color: Color(0xFF515965), fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 11),
        for (final item in _items)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFE2E8EF)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () => onSelectNarrative?.call(item.title),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(item.icon, color: item.color, size: 21),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.status,
                              style: TextStyle(
                                color: item.color,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: Color(0xFF153253),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              style: const TextStyle(
                                color: Color(0xFF515965),
                                fontSize: 11,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _VerificationIntro extends StatelessWidget {
  const _VerificationIntro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF9CEFF1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.alternate_email, size: 13, color: Color(0xFF087983)),
              SizedBox(width: 5),
              Text(
                'VERIFIKASI MULTI-MODAL AI',
                style: TextStyle(
                  color: Color(0xFF075F69),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.25,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Deteksi Narasi & Manipulasi',
          style: TextStyle(
            color: Color(0xFF0A2C50),
            fontSize: 23,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Tempel tautan HTTPS atau teks klaim politik (minimal 40 karakter). '
          'AI membandingkan klaim dengan sumber yang ditemukan; tautan menjadi '
          'konteks pemeriksaan.',
          style: TextStyle(color: Color(0xFF515965), fontSize: 14, height: 1.5),
        ),
      ],
    );
  }
}

class _AuditHeading extends StatelessWidget {
  const _AuditHeading();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.verified_user_outlined, size: 15, color: Color(0xFF775B08)),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            'Hasil Audit Forensik AI',
            style: TextStyle(
              color: Color(0xFF12345A),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Icon(Icons.update, size: 13, color: Color(0xFF07838A)),
        SizedBox(width: 4),
        Text(
          'Pembaruan: Baru saja',
          style: TextStyle(
            color: Color(0xFF515965),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
