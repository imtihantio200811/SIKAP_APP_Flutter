import 'fact_check_result.dart';

/// Model representasi data konten demo yang terdaftar dalam aplikasi.
class DemoContentItem {
  const DemoContentItem({
    required this.id,
    required this.title,
    required this.category,
    required this.sampleText,
    required this.result,
    this.badgeLabel,
    this.keywords = const [],
  });

  final String id;
  final String title;
  final String category;
  final String sampleText;
  final FactCheckResult result;
  final String? badgeLabel;
  final List<String> keywords;

  /// Memeriksa apakah input teks cocok dengan konten terdaftar ini.
  bool matches(String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return false;

    final cleanTitle = title.trim().toLowerCase();
    final cleanSample = sampleText.trim().toLowerCase();

    // 1. Cocok persis
    if (cleanQuery == cleanTitle || cleanQuery == cleanSample) {
      return true;
    }

    // 2. Query merupakan substring atau mengandung sample/title
    if (cleanSample.contains(cleanQuery) || cleanQuery.contains(cleanSample)) {
      return true;
    }
    if (cleanTitle.contains(cleanQuery) || cleanQuery.contains(cleanTitle)) {
      return true;
    }

    // 3. Cocok dengan kata kunci terdaftar
    for (final kw in keywords) {
      final cleanKw = kw.trim().toLowerCase();
      if (cleanKw.isNotEmpty &&
          (cleanQuery.contains(cleanKw) || cleanKw.contains(cleanQuery))) {
        return true;
      }
    }

    return false;
  }
}

/// Daftar konten data yang telah didaftarkan dalam proyek (pre-configured demo contents).
/// Pengguna atau pengembang dapat dengan mudah menambah, mengubah, atau menyesuaikan
/// data demo dan hasil analisis di sini tanpa membutuhkan backend/API eksternal.
const registeredDemoContents = <DemoContentItem>[
  DemoContentItem(
    id: 'deepfake-audio-dana-kampanye',
    title: 'Rekaman Suara AI Pidato Rahasia Dana Kampanye',
    category: 'Manipulasi AI',
    badgeLabel: 'HOAKS / AI DEEPFAKE',
    sampleText:
        'Rekaman Suara AI Pidato Rahasia Dana Kampanye Rp 50 Miliar Paslon Tertentu',
    keywords: [
      'rekaman suara ai',
      'dana kampanye',
      'deepfake',
      'suara sintetis',
      'pidato rahasia',
      'rekaman audio',
      'audio deepfake',
      'rekaman suara ai pidato rahasia dana kampanye',
      'https://vt.tiktok.com/zs2xdeepfakedana',
      'https://www.tiktok.com/@politik_viral/video/deepfake-dana-kampanye',
      'https://berita-viral.com/rekaman-suara-rahasia-dana-kampanye-50m',
      'https://instagram.com/reel/deepfake-suara-paslon',
    ],
    result: FactCheckResult(
      verdict: FactCheckVerdict.falseClaim,
      isPolitical: true,
      claim:
          'Rekaman Suara AI Pidato Rahasia Dana Kampanye Rp 50 Miliar Paslon Tertentu',
      summary:
          'Rekaman audio viral yang diklaim sebagai pembicaraan komitmen dana kampanye terbukti merupakan rekaman sintetis (AI deepfake voice cloning).',
      explanation:
          'Pemeriksaan forensik spektrogram audio oleh laboratorium SIKAP mendeteksi tingkat kejanggalan akustik frekuensi sintetis sebesar 96.4%. Tidak ada kecocokan dengan agenda rekaman orisinil kegiatan resmi paslon terkait.',
      confidence: 94,
      sources: [
        FactCheckSource(
          title: 'Laboratorium Forensik Suara Digital SIKAP',
          url: 'https://sikap.id/forensik/deepfake-audio-01',
        ),
        FactCheckSource(
          title: 'Klarifikasi Tim Media & Rekaman Resmi Arsip Pidato',
          url: 'https://kpu.go.id/klarifikasi/pidato-resmi',
        ),
      ],
    ),
  ),
  DemoContentItem(
    id: 'kpu-lokasi-tps',
    title: 'Pemeriksaan Lokasi TPS Melalui Kanal Resmi KPU',
    category: 'Pemilu & KPU',
    badgeLabel: 'FAKTA VALID',
    sampleText:
        'KPU mengingatkan pemilih untuk memeriksa lokasi TPS melalui kanal resmi cekdptonline.kpu.go.id',
    keywords: [
      'kpu mengingatkan pemilih',
      'lokasi tps',
      'cek dpt online',
      'kanal resmi',
      'layanan pemilih',
      'cekdptonline.kpu.go.id',
      'kpu ri',
    ],
    result: FactCheckResult(
      verdict: FactCheckVerdict.verifiedTrue,
      isPolitical: true,
      claim:
          'Pengecekan Lokasi TPS dan Hak Pilih Resmi Melalui Cek DPT Online KPU RI',
      summary:
          'Informasi valid dan resmi sesuai imbauan langsung Komisi Pemilihan Umum Republik Indonesia.',
      explanation:
          'KPU RI menyediakan kanal daring cekdptonline.kpu.go.id agar masyarakat dapat memverifikasi TPS terdaftar secara aman tanpa tautan pihak ketiga yang berisiko pencurian data.',
      confidence: 98,
      sources: [
        FactCheckSource(
          title: 'Portal Resmi KPU RI - Cek DPT Online',
          url: 'https://cekdptonline.kpu.go.id',
        ),
        FactCheckSource(
          title: 'Siaran Pers KPU RI No. 42/HM.02/2024',
          url: 'https://kpu.go.id/berita/pers-42',
        ),
      ],
    ),
  ),
  DemoContentItem(
    id: 'klaim-bansos-pilkada',
    title: 'Klaim Perubahan Skema Bantuan Sosial Pilkada',
    category: 'Kebijakan Publik',
    badgeLabel: 'DISINFORMASI',
    sampleText:
        'Klaim perubahan bantuan sosial beredar tanpa menyertakan dokumen kebijakan resmi',
    keywords: [
      'perubahan bantuan sosial',
      'bansos',
      'bantuan sosial',
      'bansos beredar tanpa menyertakan dokumen',
      'bansos pilkada',
      'dana bantuan',
      'https://vt.tiktok.com/bansos-pilkada-cair-tanpa-syarat',
      'https://kemensos.go.id/klarifikasi-bansos',
    ],
    result: FactCheckResult(
      verdict: FactCheckVerdict.falseClaim,
      isPolitical: true,
      claim:
          'Klaim Perubahan Skema Bantuan Sosial Menjelang Pilkada Tanpa Syarat Regulasi',
      summary:
          'Klaim disinformasi. Narasi mencampuradukkan dokumentasi bantuan bencana lama dengan isu politik pilkada.',
      explanation:
          'Kementerian Sosial menegaskan tidak ada perubahan aturan atau alokasi bantuan sosial mendadak. Seluruh skema bantuan tetap berpedoman pada Data Terpadu Kesejahteraan Sosial (DTKS) APBN.',
      confidence: 92,
      sources: [
        FactCheckSource(
          title: 'Kementerian Sosial RI - Pernyataan Resmi Bansos',
          url: 'https://kemensos.go.id/klarifikasi-bansos',
        ),
        FactCheckSource(
          title: 'Katalog Cek Fakta Bawaslu & Kemensos',
          url: 'https://cekfakta.kemensos.go.id',
        ),
      ],
    ),
  ),
  DemoContentItem(
    id: 'capres-tol-cepat',
    title: 'Klaim Pembangunan Cepat Jalan Tol Capres',
    category: 'Infrastruktur',
    badgeLabel: 'BUTUH KONTEKS',
    sampleText:
        'Klaim Pembangunan Cepat Capres menyelesaikan jalan tol dalam hitungan bulan',
    keywords: [
      'klaim pembangunan cepat capres',
      'klaim pembangunan cepat',
      'pembangunan cepat capres',
      'potongan video kampanye',
      'jalan tol cepat',
      'jalan tol 6 bulan',
    ],
    result: FactCheckResult(
      verdict: FactCheckVerdict.uncertain,
      isPolitical: true,
      claim:
          'Klaim Capres Menyelesaikan Proyek Jalan Tol Strategis dalam Waktu 6 Bulan',
      summary:
          'Pernyataan membutuhkan konteks tambahan karena hanya merujuk pada tahap akhir penyelesaian segmen tertentu.',
      explanation:
          'Dokumen Kementerian PUPR mencatat proyek jalan tol tersebut dirancang dan dibangun bertahap selama 3 tahun. Percepatan 6 bulan hanya berlaku pada uji fungsi seksi ruas akhir.',
      confidence: 68,
      sources: [
        FactCheckSource(
          title: 'Data Proyek Strategis Nasional Kementerian PUPR',
          url: 'https://pu.go.id/proyek-strategis',
        ),
        FactCheckSource(
          title: 'Laporan Progres Infrastruktur Nasional Bappenas',
          url: 'https://bappenas.go.id/laporan-infrastruktur',
        ),
      ],
    ),
  ),
  DemoContentItem(
    id: 'surat-suara-tercoblos',
    title: 'Klaim Surat Suara Tercoblos Sebelum Pemilihan',
    category: 'Logistik Pemilu',
    badgeLabel: 'HOAKS FABRIKASI',
    sampleText:
        'Dokumen PDF surat suara tercoblos sebelum hari pemilihan beredar di grup percakapan',
    keywords: [
      'surat suara tercoblos',
      'dokumen pdf surat suara',
      'surat suara tercoblos sebelum hari pemilihan',
      'kertas suara tercoblos',
      'https://t.me/bocor-surat-suara-tercoblos',
      'https://kpu.go.id/klarifikasi/surat-suara',
    ],
    result: FactCheckResult(
      verdict: FactCheckVerdict.falseClaim,
      isPolitical: true,
      claim:
          'Klaim Dokumen PDF Bukti Surat Suara Pilkada Sudah Tercoblos Sebelum Hari H',
      summary:
          'Hoaks fabrikasi daur ulang. Surat suara yang beredar merupakan lembar spesimen simulasi tanpa tanda pengaman KPU.',
      explanation:
          'Bawaslu dan kepolisian telah memverifikasi gudang logistik daerah dan memastikan seluruh surat suara asli masih berada dalam segel barcode dan dalam pengawalan ketat.',
      confidence: 96,
      sources: [
        FactCheckSource(
          title: 'Bawaslu RI - Laporan Pengawasan Logistik Surat Suara',
          url: 'https://bawaslu.go.id/laporan/logistik-suara',
        ),
        FactCheckSource(
          title: 'KPU RI - Klarifikasi Spesimen vs Surat Suara Resmi',
          url: 'https://kpu.go.id/klarifikasi/surat-suara',
        ),
      ],
    ),
  ),
  DemoContentItem(
    id: 'foto-antrean-lama',
    title: 'Foto Antrean Bantuan Lama Diklaim Kondisi Hari Ini',
    category: 'Pemeriksaan Visual',
    badgeLabel: 'MANIPULASI GAMBAR',
    sampleText:
        'Foto antrean bantuan lama diklaim sebagai kondisi hari ini di kantor kecamatan',
    keywords: [
      'foto antrean bantuan lama',
      'foto antrean bantuan lama diklaim sebagai kondisi hari ini',
      'foto antrean lama',
      'antrean bantuan',
    ],
    result: FactCheckResult(
      verdict: FactCheckVerdict.falseClaim,
      isPolitical: true,
      claim:
          'Foto Kericuhan Antrean Sembako di Kantor Kecamatan Terjadi Hari Ini',
      summary:
          'Manipulasi konteks foto. Foto tersebut merupakan dokumentasi tahun 2020 saat masa pandemi di lokasi lain.',
      explanation:
          'Pemeriksaan reverse image search membuktikan foto identik telah dipublikasikan pada portal berita regional pada September 2020 saat penyaluran bansos darurat Covid-19.',
      confidence: 97,
      sources: [
        FactCheckSource(
          title: 'Laboratorium Forensik Visual SIKAP - Reverse Search',
          url: 'https://sikap.id/forensik/foto-antrean-2020',
        ),
        FactCheckSource(
          title: 'Dokumentasi Publik Humas Kecamatan',
          url: 'https://kecamatan.go.id/arsip/2020-bansos',
        ),
      ],
    ),
  ),
  DemoContentItem(
    id: 'ai-literasi-deepfake',
    title: 'Penyebaran Hoaks AI Deepfake Meningkat',
    category: 'Literasi Digital',
    badgeLabel: 'FAKTA VALID',
    sampleText:
        'Penyebaran hoaks berbasis AI deepfake meningkat, pakar dorong literasi verifikasi visual',
    keywords: [
      'penyebaran hoaks berbasis ai deepfake',
      'ai deepfake meningkat',
      'literasi verifikasi visual',
      'pakar dorong literasi',
      'deepfake meningkat',
    ],
    result: FactCheckResult(
      verdict: FactCheckVerdict.verifiedTrue,
      isPolitical: true,
      claim:
          'Pakar Mengonfirmasi Kenaikan Sebaran Disinformasi Berbasis AI Menjelang Pemilu',
      summary:
          'Fakta valid sesuai temuan gabungan komunitas cek fakta dan dewan pers.',
      explanation:
          'Pemantauan lintas platform mencatat peningkatan konten sintetis deepfake video dan suara sepanjang kuartal ini yang menargetkan kandidat pemilu untuk memicu polarisasi.',
      confidence: 91,
      sources: [
        FactCheckSource(
          title: 'Konsorsium Cek Fakta Indonesia - Laporan Tahunan',
          url: 'https://cekfakta.com/laporan-tahunan-ai',
        ),
        FactCheckSource(
          title: 'Panduan Edukasi Literasi Digital Kemkominfo',
          url: 'https://literasidigital.id/panduan-deepfake',
        ),
      ],
    ),
  ),
  DemoContentItem(
    id: 'kutipan-pidato-konteks',
    title: 'Kutipan Pidato Beredar Tanpa Rekaman Lengkap',
    category: 'Analisis Wacana',
    badgeLabel: 'BUTUH KONTEKS',
    sampleText:
        'Kutipan pidato beredar tanpa rekaman lengkap mengenai pemotongan anggaran layanan publik',
    keywords: [
      'kutipan pidato beredar tanpa rekaman lengkap',
      'kutipan pidato',
      'rekaman lengkap',
      'periksa konteks sebelum dan sesudah',
    ],
    result: FactCheckResult(
      verdict: FactCheckVerdict.uncertain,
      isPolitical: true,
      claim:
          'Kutipan Pernyataan Paslon Ingin Memangkas Anggaran Pelayanan Publik',
      summary:
          'Kutipan dipotong tanpa konteks lengkap sehingga maknanya terdistorsi.',
      explanation:
          'Rekaman video utuh memperlihatkan pembicara mengusulkan efisiensi pos seremonial untuk dialihkan ke peningkatan beasiswa dan fasilitas kesehatan primer.',
      confidence: 76,
      sources: [
        FactCheckSource(
          title: 'Transkrip Lengkap Pidato Balai Pertemuan',
          url: 'https://arsip.sikap.id/transkrip-08',
        ),
        FactCheckSource(
          title: 'Rekaman Siaran Langsung Kanal Media Publik',
          url: 'https://mediapublik.id/video/pidato-penuh',
        ),
      ],
    ),
  ),
  DemoContentItem(
    id: 'test-flow-claim',
    title: 'Klaim Uji Verifikasi Data Resmi',
    category: 'Pengujian Sistem',
    badgeLabel: 'FAKTA VALID',
    sampleText: 'Klaim politik yang perlu diperiksa berdasarkan data resmi.',
    keywords: [
      'klaim politik yang perlu diperiksa berdasarkan data resmi',
      'klaim politik yang dibagikan',
      'klaim politik yang perlu diperiksa',
    ],
    result: FactCheckResult(
      verdict: FactCheckVerdict.verifiedTrue,
      isPolitical: true,
      claim: 'Klaim politik yang perlu diperiksa berdasarkan data resmi.',
      summary:
          'Klaim didukung oleh data dan sumber resmi yang telah diverifikasi.',
      explanation:
          'Pemeriksaan silang terhadap arsip data terbuka membuktikan bahwa substansi klaim sesuai dengan catatan statistik resmi kementerian terkait.',
      confidence: 86,
      sources: [
        FactCheckSource(
          title: 'Portal Satu Data Indonesia',
          url: 'https://data.go.id',
        ),
        FactCheckSource(
          title: 'Publikasi BPS: Statistik Terkini',
          url: 'https://bps.go.id',
        ),
      ],
    ),
  ),
  DemoContentItem(
    id: 'berita-non-politik',
    title: 'Resep Kuliner Nusantara Rendang Tradisional',
    category: 'Non-Politik',
    badgeLabel: 'NON-POLITIK',
    sampleText:
        'Resep masakan nusantara dan cara membuat rendang padang asli Minang',
    keywords: [
      'resep masakan',
      'berita kuliner',
      'rendang padang',
      'kuliner',
    ],
    result: FactCheckResult(
      verdict: FactCheckVerdict.notPolitical,
      isPolitical: false,
      claim: 'Resep kuliner nusantara',
      summary: 'Tidak ada konten politik yang terdeteksi.',
      explanation:
          'Konten berada di luar cakupan analisis politik dan pemilu SIKAP.',
      confidence: 99,
      sources: [],
      triggerToast: true,
      toastMessage:
          'Tidak ada konten politik yang terdeteksi pada layar saat ini.',
    ),
  ),
];

/// Mencari apakah suatu query/konten terdaftar dalam katalog konten demo.
DemoContentItem? findRegisteredDemoContent(String query) {
  final clean = query.trim();
  if (clean.isEmpty) return null;
  for (final item in registeredDemoContents) {
    if (item.matches(clean)) {
      return item;
    }
  }
  return null;
}

/// Menghasilkan FactCheckResult ketika konten TIDAK terdaftar dalam sistem demo.
FactCheckResult createUnlistedDemoResult(String query) {
  final clean = query.trim();
  final displayClaim =
      clean.length > 70 ? '${clean.substring(0, 67)}...' : clean;

  return FactCheckResult(
    verdict: FactCheckVerdict.insufficientContext,
    isPolitical: true,
    claim: displayClaim.isEmpty ? 'Konten di luar database demo' : displayClaim,
    summary: 'Konten tidak terdaftar dalam database demo.',
    explanation:
        'Mode demo SIKAP berjalan secara offline/lokal tanpa memerlukan API '
        'dan hanya dapat menganalisis data konten yang telah didaftarkan dalam kode/proyek. '
        'Konten yang Anda masukkan saat ini belum ada di dalam daftar demo. '
        'Silakan pilih contoh konten demo yang tersedia dari menu pop-up untuk melihat hasil analisis.',
    confidence: 0,
    sources: const [
      FactCheckSource(
        title: 'Katalog Konten Demo SIKAP (Offline)',
        url: 'https://sikap.app/demo-mode',
      ),
    ],
  );
}
