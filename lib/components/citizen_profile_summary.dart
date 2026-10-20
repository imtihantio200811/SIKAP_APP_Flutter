import 'package:flutter/material.dart';

class CitizenProfileSummary extends StatelessWidget {
  const CitizenProfileSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [Colors.white, Color(0xFFE0F8F8)],
          stops: [0.55, 1],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0B142B43),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const _CitizenAvatar(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Aditya Pratama',
                      style: TextStyle(
                        color: Color(0xFF18253B),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      '@adityapratama • Pengawal Demokrasi\nLevel 3',
                      style: TextStyle(
                        color: Color(0xFF505763),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4E9FF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        '🏅 Kontributor Aktif Anti-Hoaks',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF16365B),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1FF),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🏅', style: TextStyle(fontSize: 11)),
                    const SizedBox(width: 4),
                    const Expanded(
                      child: Text(
                        'Progres Menuju Level 4 (Pilar Literasi)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF252D3C),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '84%',
                      style: TextStyle(
                        color: Color(0xFF0A2C50),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 0.84,
                    minHeight: 7,
                    backgroundColor: Color(0xFFDCE3FF),
                    color: Color(0xFF123966),
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Kurang 3 verifikasi lagi untuk membuka Lencana '
                  'Verifikator Utama',
                  style: TextStyle(
                    color: Color(0xFF505763),
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CitizenAvatar extends StatelessWidget {
  const _CitizenAvatar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 68,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFE5E9F6),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Color(0xFF516781), size: 43),
          ),
          Positioned(
            right: 0,
            bottom: 1,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF00828A),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.verified, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}
