import 'package:flutter/foundation.dart';

import '../models/fact_check_result.dart';
import '../services/fact_check_service.dart';

enum FactCheckStatus { idleMonitoring, loading, complete }

class FactCheckController extends ChangeNotifier {
  FactCheckController(this._service, {this.onToast, DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final FactCheckService _service;
  final void Function(String message)? onToast;
  final DateTime Function() _now;

  FactCheckStatus _status = FactCheckStatus.idleMonitoring;
  FactCheckResult? _result;
  String? _sharedContent;
  DateTime? _lastToastAt;

  FactCheckStatus get status => _status;
  FactCheckResult? get result => _result;
  String? get sharedContent => _sharedContent;
  bool get isScanning => _status == FactCheckStatus.loading;

  Future<FactCheckResult?> analyzeSharedContent(String content) async {
    final normalizedContent = content.trim();
    if (normalizedContent.isEmpty) {
      _result = null;
      _sharedContent = null;
      _status = FactCheckStatus.idleMonitoring;
      notifyListeners();
      _showToast('Tidak ada teks yang dapat dianalisis di layar');
      return null;
    }

    _sharedContent = normalizedContent;
    _result = null;
    _status = FactCheckStatus.loading;
    notifyListeners();
    final startedAt = DateTime.now();

    try {
      final result = await _service.analyze(normalizedContent);
      if (result.triggerToast && !result.isPolitical) {
        _result = null;
        _status = FactCheckStatus.idleMonitoring;
        notifyListeners();
        _showToast(
          result.toastMessage ??
              'Tidak ada konten politik yang terdeteksi pada layar saat ini.',
        );
        return null;
      }
      await _finishMinimumLoadingTime(startedAt);
      _result = result;
    } on FactCheckException catch (error) {
      await _finishMinimumLoadingTime(startedAt);
      _result = _analysisError(error.message);
    }

    _status = FactCheckStatus.complete;
    notifyListeners();
    return _result;
  }

  void reset() {
    _status = FactCheckStatus.idleMonitoring;
    _result = null;
    _sharedContent = null;
    notifyListeners();
  }

  void _showToast(String message) {
    final now = _now();
    if (_lastToastAt != null &&
        now.difference(_lastToastAt!) < const Duration(seconds: 5)) {
      return;
    }
    _lastToastAt = now;
    onToast?.call(message);
  }

  Future<void> _finishMinimumLoadingTime(DateTime startedAt) async {
    const minimumDuration = Duration(milliseconds: 1400);
    final elapsed = DateTime.now().difference(startedAt);
    final remaining = minimumDuration - elapsed;
    if (remaining > Duration.zero) await Future<void>.delayed(remaining);
  }

  FactCheckResult _analysisError(String message) => FactCheckResult(
    verdict: FactCheckVerdict.analysisError,
    isPolitical: false,
    claim: 'Analisis belum tersedia',
    summary: message,
    explanation:
        'Periksa koneksi internet dan konfigurasi Gemini, lalu bagikan konten '
        'kembali ke SIKAP.',
    confidence: 0,
    sources: const [],
  );
}
