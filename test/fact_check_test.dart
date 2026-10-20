import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sikap_project/components/fact_check_result_overlay.dart';
import 'package:sikap_project/controllers/fact_check_controller.dart';
import 'package:sikap_project/models/fact_check_result.dart';
import 'package:sikap_project/services/fact_check_service.dart';

const _sampleResult = FactCheckResult(
  verdict: FactCheckVerdict.verifiedTrue,
  isPolitical: true,
  claim: 'Contoh klaim politik.',
  summary: 'Klaim didukung oleh sumber yang tersedia.',
  explanation: 'Sumber primer mengonfirmasi klaim tersebut.',
  confidence: 86,
  sources: [
    FactCheckSource(title: 'Sumber resmi', url: 'https://example.com/fakta'),
  ],
);

void main() {
  test('fact-check result serializes and parses without optional sources', () {
    final map = _sampleResult.toMap()
      ..remove('type')
      ..remove('sources');
    final parsed = FactCheckResult.fromMap(map);

    expect(parsed.verdict, FactCheckVerdict.verifiedTrue);
    expect(parsed.isPolitical, isTrue);
    expect(parsed.confidence, 86);
    expect(parsed.sources, isEmpty);
  });

  test(
    'empty extracted text does not call analysis and shows one toast',
    () async {
      var analyzeCalls = 0;
      final messages = <String>[];
      final controller = FactCheckController(
        _FakeFactCheckService(
          onAnalyze: (_) async {
            analyzeCalls++;
            return _sampleResult;
          },
        ),
        onToast: messages.add,
      );
      addTearDown(controller.dispose);

      final result = await controller.analyzeSharedContent(' \n ');

      expect(result, isNull);
      expect(analyzeCalls, 0);
      expect(controller.status, FactCheckStatus.idleMonitoring);
      expect(controller.isScanning, isFalse);
      expect(messages, ['Tidak ada teks yang dapat dianalisis di layar']);
    },
  );

  test(
    'non-political results stop loading and never complete a result popup',
    () async {
      final messages = <String>[];
      final controller = FactCheckController(
        _FakeFactCheckService(
          onAnalyze: (_) async => const FactCheckResult(
            verdict: FactCheckVerdict.notPolitical,
            isPolitical: false,
            claim: 'Konten umum',
            summary: 'Tidak ada konten politik yang terdeteksi.',
            explanation: 'Di luar cakupan analisis politik.',
            confidence: 99,
            sources: [],
            triggerToast: true,
            toastMessage:
                'Tidak ada konten politik yang terdeteksi pada layar saat ini.',
          ),
        ),
        onToast: messages.add,
      );
      addTearDown(controller.dispose);

      final result = await controller.analyzeSharedContent('Berita kuliner.');

      expect(result, isNull);
      expect(controller.status, FactCheckStatus.idleMonitoring);
      expect(controller.result, isNull);
      expect(controller.isScanning, isFalse);
      expect(messages, [
        'Tidak ada konten politik yang terdeteksi pada layar saat ini.',
      ]);
    },
  );

  test('toast notifications have a five-second cooldown', () async {
    var now = DateTime(2026);
    final messages = <String>[];
    final controller = FactCheckController(
      _FakeFactCheckService(),
      onToast: messages.add,
      now: () => now,
    );
    addTearDown(controller.dispose);

    await controller.analyzeSharedContent('');
    await controller.analyzeSharedContent('');
    expect(messages, hasLength(1));

    now = now.add(const Duration(seconds: 5));
    await controller.analyzeSharedContent('');
    expect(messages, hasLength(2));
  });

  testWidgets('shows verdict popup and opens closable facts panel', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = FactCheckController(_FakeFactCheckService());
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Stack(
          children: [
            const Scaffold(body: Text('Halaman utama')),
            FactCheckResultOverlay(controller: controller),
          ],
        ),
      ),
    );

    final analysis = controller.analyzeSharedContent('Konten yang dibagikan');
    await tester.pump();
    expect(find.text('Memeriksa konten...'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1400));
    await analysis;
    await tester.pumpAndSettle();

    expect(find.text('Lencana SIKAP'), findsOneWidget);
    expect(find.text('Cenderung Fakta'), findsOneWidget);
    await tester.tap(find.text('Detail Fakta').first);
    await tester.pumpAndSettle();
    expect(find.text('Detail Fakta'), findsNWidgets(2));
    expect(find.text('Contoh klaim politik.'), findsOneWidget);

    await tester.tapAt(const Offset(12, 12));
    await tester.pumpAndSettle();
    expect(find.text('Detail Fakta'), findsOneWidget);
  });
}

class _FakeFactCheckService implements FactCheckService {
  _FakeFactCheckService({this.onAnalyze});

  final Future<FactCheckResult> Function(String content)? onAnalyze;

  @override
  Future<FactCheckResult> analyze(String sharedContent) async =>
      onAnalyze?.call(sharedContent) ?? _sampleResult;
}
