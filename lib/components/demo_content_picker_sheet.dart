import 'package:flutter/material.dart';

import '../models/demo_fact_check_data.dart';
import 'fact_check_presentation.dart';

/// Membuka pop-up modal bottom sheet yang menampilkan daftar konten demo terdaftar
/// sehingga pengguna dapat mengklik konten tersebut untuk langsung dianalisis.
Future<void> showDemoContentPickerModal(
  BuildContext context, {
  required ValueChanged<String> onSelected,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _DemoContentPickerSheet(onSelected: onSelected),
  );
}

class _DemoContentPickerSheet extends StatelessWidget {
  const _DemoContentPickerSheet({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height * 0.82;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          // Handle bar
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD6DBE1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2EDF8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.dataset_outlined,
                    color: Color(0xFF123966),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Konten Demo (Tanpa API)',
                        style: TextStyle(
                          color: Color(0xFF0A2C50),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Klik narasi terdaftar untuk langsung menganalisis data',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20),
                  color: const Color(0xFF6B7280),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Banner info mode demo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F5FA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD9E2EC)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 15, color: Color(0xFF1A5276)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Mode offline: Hanya konten yang didaftarkan dalam kode yang dapat diverifikasi penuh.',
                      style: TextStyle(
                        color: Color(0xFF1A5276),
                        fontSize: 11,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFEEF2F6)),
          // List item
          Flexible(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
              children: [
                for (final item in registeredDemoContents)
                  _buildDemoCard(context, item),
                const SizedBox(height: 10),
                _buildUnlistedTesterCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard(BuildContext context, DemoContentItem item) {
    final statusColor = FactCheckPresentation.color(item.result.verdict);
    final statusLabel =
        item.badgeLabel ?? FactCheckPresentation.label(item.result.verdict);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.pop(context);
            onSelected(item.sampleText);
          },
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${item.category}',
                      style: const TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (item.result.confidence > 0)
                      Text(
                        '${item.result.confidence}% yakin',
                        style: const TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Color(0xFF102A43),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.sampleText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF4A5568),
                    fontSize: 11.5,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Klik untuk analisis',
                      style: TextStyle(
                        color: Color(0xFF123966),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 13,
                      color: const Color(0xFF123966),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnlistedTesterCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.pop(context);
            onSelected(
              'Klaim bebas acak: Rencana anggaran proyek xyz yang tidak terdaftar',
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECB3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.help_outline,
                    color: Color(0xFFB78103),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Uji Kasus Konten Tidak Terdaftar',
                        style: TextStyle(
                          color: Color(0xFF7C5000),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Kirim teks acak untuk menguji respon penolakan/belum terdaftar.',
                        style: TextStyle(
                          color: Color(0xFF8D6E63),
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFB78103),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
