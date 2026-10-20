import '../models/demo_fact_check_data.dart';
import '../models/fact_check_result.dart';
import 'fact_check_service.dart';

/// Implementasi FactCheckService untuk demo offline/lokal tanpa memerlukan API backend sama sekali.
/// Hanya konten yang telah didaftarkan dalam [registeredDemoContents] yang akan dianalisis secara lengkap.
/// Konten lain di luar daftar akan mengembalikan hasil bahwa konten tidak terdaftar dalam database demo.
class LocalFactCheckService implements FactCheckService {
  const LocalFactCheckService({
    this.demoItems = registeredDemoContents,
  });

  final List<DemoContentItem> demoItems;

  List<DemoContentItem> get availableDemoContents => demoItems;

  @override
  Future<FactCheckResult> analyze(String sharedContent) async {
    final clean = sharedContent.trim();
    if (clean.isEmpty) {
      throw const FactCheckException(
        'Teks konten kosong. Masukkan atau pilih konten untuk dianalisis.',
      );
    }

    // Cari kecocokan di antara konten yang telah didaftarkan
    for (final item in demoItems) {
      if (item.matches(clean)) {
        return item.result;
      }
    }

    // Jika tidak cocok dengan konten terdaftar mana pun
    return createUnlistedDemoResult(clean);
  }
}
