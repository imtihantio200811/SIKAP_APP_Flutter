import 'package:flutter/material.dart';

class DashboardNewsFeed extends StatelessWidget {
  const DashboardNewsFeed({super.key, this.onSelectNews});

  final ValueChanged<String>? onSelectNews;

  static const _news = [
    (
      category: 'PEMILU',
      time: '12 menit lalu',
      title: 'KPU mengingatkan pemilih untuk memeriksa lokasi TPS melalui kanal resmi',
      source: 'KPU RI · Informasi layanan pemilih',
      icon: Icons.how_to_vote_outlined,
      color: Color(0xFF167B69),
    ),
    (
      category: 'KEBIJAKAN',
      time: '38 menit lalu',
      title: 'Klaim perubahan bantuan sosial beredar tanpa menyertakan dokumen kebijakan',
      source: 'Pemantauan SIKAP · Perlu verifikasi',
      icon: Icons.policy_outlined,
      color: Color(0xFFB87912),
    ),
    (
      category: 'CEK FAKTA',
      time: '1 jam lalu',
      title: 'Arsip pernyataan kandidat tersedia untuk dibandingkan dengan potongan video',
      source: 'Arsip publik · Konteks tambahan',
      icon: Icons.fact_check_outlined,
      color: Color(0xFF315D91),
    ),
    (
      category: 'LITERASI',
      time: '2 jam lalu',
      title: 'Kenali ciri gambar lama yang dibagikan ulang sebagai peristiwa terkini',
      source: 'Panduan pemeriksaan konten',
      icon: Icons.image_search_outlined,
      color: Color(0xFF7555A0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Berita & Pemantauan',
          style: TextStyle(
            color: Color(0xFF0A3159),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        for (final item in _news)
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
                onTap: () => onSelectNews?.call(item.title),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(item.icon, color: item.color, size: 21),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.category,
                                    style: TextStyle(
                                      color: item.color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.35,
                                    ),
                                  ),
                                ),
                                Text(
                                  item.time,
                                  style: const TextStyle(
                                    color: Color(0xFF737B87),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: Color(0xFF172033),
                                fontSize: 13,
                                height: 1.35,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item.source,
                              style: const TextStyle(
                                color: Color(0xFF687486),
                                fontSize: 11,
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
