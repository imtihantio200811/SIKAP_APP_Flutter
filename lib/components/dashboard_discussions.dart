import 'package:flutter/material.dart';

class DashboardDiscussions extends StatefulWidget {
  const DashboardDiscussions({super.key});

  @override
  State<DashboardDiscussions> createState() => _DashboardDiscussionsState();
}

class _DiscussionItem {
  const _DiscussionItem({
    required this.category,
    required this.title,
    required this.time,
    required this.source,
    required this.tag,
    required this.icon,
    required this.color,
  });

  final String category;
  final String title;
  final String time;
  final String source;
  final String tag;
  final IconData icon;
  final Color color;
}

class _DashboardDiscussionsState extends State<DashboardDiscussions> {
  String _selectedCategory = 'Semua';

  static const _categories = [
    'Semua',
    'Pilkada',
    'Kebijakan',
    'Ekonomi',
    'Hukum',
    'Teknologi',
    'Pendidikan',
    'Kesehatan',
    'Lingkungan',
    'Sosial',
  ];

  static const _allDiscussions = [
    _DiscussionItem(
      category: 'Pilkada',
      title: 'KPU matangkan aturan debat publik paslon demi transparansi visi misi daerah',
      time: '15 menit lalu',
      source: 'Forum Warga SIKAP · 42 tanggapan',
      tag: 'Sedang Hangat',
      icon: Icons.how_to_vote_outlined,
      color: Color(0xFF167B69),
    ),
    _DiscussionItem(
      category: 'Kebijakan',
      title: 'Rancangan regulasi subsidi transportasi menuai respon beragam dari asosiasi warga',
      time: '35 menit lalu',
      source: 'Kanal Regulasi Publik · 28 tanggapan',
      tag: 'Perlu Verifikasi',
      icon: Icons.gavel_outlined,
      color: Color(0xFFB87912),
    ),
    _DiscussionItem(
      category: 'Ekonomi',
      title: 'Lonjakan harga pangan pokok jelang akhir tahun, pengamat tekankan stabilisasi pasokan',
      time: '1 jam lalu',
      source: 'Pantauan Pasar Warga · 64 tanggapan',
      tag: 'Tren Ekonomi',
      icon: Icons.trending_up_outlined,
      color: Color(0xFF2878B8),
    ),
    _DiscussionItem(
      category: 'Hukum',
      title: 'KPK perketat pemantauan integritas pengadaan barang dan jasa di tingkat daerah',
      time: '2 jam lalu',
      source: 'Klinik Hukum & Transparansi · 36 tanggapan',
      tag: 'Sorotan Publik',
      icon: Icons.balance_outlined,
      color: Color(0xFF8A3B8F),
    ),
    _DiscussionItem(
      category: 'Teknologi',
      title: 'Penyebaran hoaks berbasis AI deepfake meningkat, pakar dorong literasi verifikasi visual',
      time: '3 jam lalu',
      source: 'Laboratorium Cek Fakta · 51 tanggapan',
      tag: 'Cek Fakta AI',
      icon: Icons.memory_outlined,
      color: Color(0xFF1F7A8C),
    ),
    _DiscussionItem(
      category: 'Pendidikan',
      title: 'Pemerataan alokasi bantuan operasional sekolah jadi sorotan dalam rapat evaluasi',
      time: '4 jam lalu',
      source: 'Ruang Pendidik Mandiri · 19 tanggapan',
      tag: 'Evaluasi Kebijakan',
      icon: Icons.school_outlined,
      color: Color(0xFF2E7D32),
    ),
    _DiscussionItem(
      category: 'Kesehatan',
      title: 'Kemenkes rilis panduan pencegahan lonjakan ISPA di kawasan industri perkotaan',
      time: '5 jam lalu',
      source: 'Pojok Sehat Warga · 23 tanggapan',
      tag: 'Info Resmi',
      icon: Icons.health_and_safety_outlined,
      color: Color(0xFFD32F2F),
    ),
    _DiscussionItem(
      category: 'Lingkungan',
      title: 'Uji coba program pengurangan sampah plastik sekali pakai diperluas ke pasar tradisional',
      time: '6 jam lalu',
      source: 'Aksi Hijau Komunitas · 31 tanggapan',
      tag: 'Aksi Komunitas',
      icon: Icons.forest_outlined,
      color: Color(0xFF388E3C),
    ),
    _DiscussionItem(
      category: 'Sosial',
      title: 'Inisiatif lumbung pangan mandiri berbasis RT perkuat jaring pengaman sosial warga',
      time: '7 jam lalu',
      source: 'Jejaring Solidaritas Warga · 47 tanggapan',
      tag: 'Inspirasi Warga',
      icon: Icons.groups_outlined,
      color: Color(0xFFE65100),
    ),
  ];

  List<_DiscussionItem> get _filteredDiscussions {
    if (_selectedCategory == 'Semua') {
      return _allDiscussions;
    }
    return _allDiscussions
        .where((d) => d.category.toLowerCase() == _selectedCategory.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredDiscussions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TOPIK DISKUSI',
              style: TextStyle(
                color: Color(0xFF414955),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            Text(
              'Geser kategori  ›',
              style: TextStyle(
                color: Color(0xFF414955),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = category == _selectedCategory;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF123966) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF123966)
                          : const Color(0xFFD7DDE4),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF123966).withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF555C67),
                        fontSize: 11.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        if (filtered.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFE2E8EF)),
            ),
            child: Center(
              child: Text(
                'Belum ada topik diskusi untuk kategori "$_selectedCategory".',
                style: const TextStyle(
                  color: Color(0xFF737B87),
                  fontSize: 12,
                ),
              ),
            ),
          )
        else
          for (final item in filtered)
            _DiscussionCard(item: item),
      ],
    );
  }
}

class _DiscussionCard extends StatelessWidget {
  const _DiscussionCard({required this.item});

  final _DiscussionItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE2E8EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(item.icon, color: item.color, size: 15),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.category.toUpperCase(),
                      style: TextStyle(
                        color: item.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.35,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.tag,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item.time,
                style: const TextStyle(
                  color: Color(0xFF737B87),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: const TextStyle(
              color: Color(0xFF172033),
              fontSize: 13,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.forum_outlined,
                size: 13,
                color: Color(0xFF687486),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  item.source,
                  style: const TextStyle(
                    color: Color(0xFF687486),
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
