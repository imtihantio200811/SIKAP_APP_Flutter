import 'package:flutter/material.dart';

import 'dashboard_trend_card.dart';

class DashboardTrending extends StatelessWidget {
  const DashboardTrending({super.key, this.onSelectTrend});

  final ValueChanged<String>? onSelectTrend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.local_fire_department_outlined,
              color: Color(0xFFD4212A),
              size: 21,
            ),
            const SizedBox(width: 3),
            const Expanded(
              child: Text(
                'Trending Verifikasi',
                style: TextStyle(
                  color: Color(0xFF0A3159),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF008189),
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                children: [
                  Text(
                    'Lihat Semua',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Icon(Icons.chevron_right, size: 17),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        SizedBox(
          height: 191,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: 280,
                child: DashboardTrendCard(
                  label: 'HOAKS / MANIPULASI',
                  age: '15 mnt lalu',
                  title: 'Rekaman Suara AI Pidato Rahasia Dana Kampanye Rp...',
                  description:
                      'Audio deepfake menyerupai salah satu paslon '
                      'membicarakan komitmen dana...',
                  score: 'Trust: 12% (Kritis)',
                  views: 'TikTok (1.2M views)',
                  progress: 0.12,
                  labelColor: const Color(0xFFFFDEDE),
                  labelForeground: const Color(0xFFB8131C),
                  progressColor: const Color(0xFFC91925),
                  cardTint: const Color(0xFFFFF2F2),
                  leadingIcon: Icons.cancel_outlined,
                  onTap: () {
                    onSelectTrend?.call(
                      'Rekaman Suara AI Pidato Rahasia Dana Kampanye Rp 50 Miliar Paslon Tertentu',
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 230,
                child: DashboardTrendCard(
                  label: 'BUTUH VERIFIKASI',
                  age: '32 mnt lalu',
                  title: 'Klaim Pembangunan Cepat Capres',
                  description:
                      'Potongan video kampanye viral perlu diperiksa sumber '
                      'dan konteks lengkapnya...',
                  score: 'Trust: 58% (Sedang)',
                  views: 'Reels (840K views)',
                  progress: 0.58,
                  labelColor: const Color(0xFFFFE8C7),
                  labelForeground: const Color(0xFF98620C),
                  progressColor: const Color(0xFFE6AD4D),
                  cardTint: const Color(0xFFFFF8ED),
                  leadingIcon: Icons.help_outline,
                  onTap: () {
                    onSelectTrend?.call(
                      'Klaim Pembangunan Cepat Capres menyelesaikan jalan tol dalam hitungan bulan',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
