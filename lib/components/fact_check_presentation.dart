import 'package:flutter/material.dart';

import '../models/fact_check_result.dart';

abstract final class FactCheckPresentation {
  static Color color(FactCheckVerdict verdict) => switch (verdict) {
    FactCheckVerdict.verifiedTrue => const Color(0xFF16844A),
    FactCheckVerdict.falseClaim => const Color(0xFFD64545),
    FactCheckVerdict.uncertain ||
    FactCheckVerdict.insufficientContext ||
    FactCheckVerdict.notChecked => const Color(0xFFCA8A04),
    FactCheckVerdict.notPolitical => const Color(0xFF2878B8),
    FactCheckVerdict.analysisError => const Color(0xFF64748B),
  };

  static String label(FactCheckVerdict verdict) => switch (verdict) {
    FactCheckVerdict.verifiedTrue => 'Cenderung Fakta',
    FactCheckVerdict.falseClaim => 'Terindikasi Hoaks',
    FactCheckVerdict.uncertain => 'Belum Terverifikasi',
    FactCheckVerdict.notPolitical => 'Bukan Konten Politik',
    FactCheckVerdict.insufficientContext => 'Konteks Tidak Cukup',
    FactCheckVerdict.analysisError => 'Pemeriksaan Gagal',
    FactCheckVerdict.notChecked => 'Belum ada hasil',
  };

  static IconData icon(FactCheckVerdict verdict) => switch (verdict) {
    FactCheckVerdict.verifiedTrue => Icons.verified_outlined,
    FactCheckVerdict.falseClaim => Icons.report_gmailerrorred_outlined,
    FactCheckVerdict.uncertain ||
    FactCheckVerdict.insufficientContext ||
    FactCheckVerdict.notChecked => Icons.help_outline,
    FactCheckVerdict.notPolitical => Icons.info_outline,
    FactCheckVerdict.analysisError => Icons.cloud_off_outlined,
  };
}
