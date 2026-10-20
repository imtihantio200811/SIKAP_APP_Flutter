import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sikap_project/components/demo_content_picker_sheet.dart';
import 'package:sikap_project/models/fact_check_result.dart';
import 'package:sikap_project/services/fact_check_service.dart';
import 'package:sikap_project/services/local_fact_check_service.dart';

void main() {
  group('LocalFactCheckService', () {
    const service = LocalFactCheckService();

    test('throws FactCheckException when content is empty', () async {
      expect(
        () => service.analyze('   '),
        throwsA(isA<FactCheckException>()),
      );
    });

    test('analyzes registered deepfake audio content correctly', () async {
      final result = await service.analyze(
        'Rekaman Suara AI Pidato Rahasia Dana Kampanye Rp 50 Miliar Paslon Tertentu',
      );

      expect(result.verdict, FactCheckVerdict.falseClaim);
      expect(result.isPolitical, isTrue);
      expect(result.confidence, 94);
      expect(result.sources, isNotEmpty);
      expect(result.sources.first.title, contains('Forensik'));
    });

    test('analyzes registered content by keyword or partial phrase', () async {
      final result = await service.analyze('cek dpt online kpu');

      expect(result.verdict, FactCheckVerdict.verifiedTrue);
      expect(result.isPolitical, isTrue);
      expect(result.confidence, 98);
      expect(result.claim, contains('Cek DPT Online KPU RI'));
    });

    test('handles non-political registered sample', () async {
      final result = await service.analyze('resep kuliner nusantara');

      expect(result.verdict, FactCheckVerdict.notPolitical);
      expect(result.isPolitical, isFalse);
      expect(result.triggerToast, isTrue);
      expect(
        result.toastMessage,
        'Tidak ada konten politik yang terdeteksi pada layar saat ini.',
      );
    });

    test('returns unlisted result when content is not registered', () async {
      final result = await service.analyze('Klaim antariksa asing di planet mars');

      expect(result.verdict, FactCheckVerdict.insufficientContext);
      expect(result.confidence, 0);
      expect(result.summary, 'Konten tidak terdaftar dalam database demo.');
      expect(
        result.explanation,
        contains('hanya dapat menganalisis data konten yang telah didaftarkan'),
      );
    });
  });

  group('DemoContentPickerSheet Widget', () {
    testWidgets('displays registered demo contents and allows selection', (
      WidgetTester tester,
    ) async {
      String? selectedContent;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDemoContentPickerModal(
                    context,
                    onSelected: (text) => selectedContent = text,
                  );
                },
                child: const Text('Buka Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Buka Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Pilih Konten Demo (Tanpa API)'), findsOneWidget);
      expect(
        find.text('Rekaman Suara AI Pidato Rahasia Dana Kampanye'),
        findsOneWidget,
      );
      expect(find.text('HOAKS / AI DEEPFAKE'), findsOneWidget);
      expect(
        find.text('Pemeriksaan Lokasi TPS Melalui Kanal Resmi KPU'),
        findsOneWidget,
      );

      // Tap on first demo item
      await tester.tap(
        find.text('Rekaman Suara AI Pidato Rahasia Dana Kampanye'),
      );
      await tester.pumpAndSettle();

      expect(selectedContent, contains('Rekaman Suara AI'));
      // Sheet should be dismissed
      expect(find.text('Pilih Konten Demo (Tanpa API)'), findsNothing);
    });

    testWidgets('allows selecting unlisted test case', (
      WidgetTester tester,
    ) async {
      String? selectedContent;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDemoContentPickerModal(
                    context,
                    onSelected: (text) => selectedContent = text,
                  );
                },
                child: const Text('Buka Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Buka Modal'));
      await tester.pumpAndSettle();

      // Scroll down to find the unlisted tester card if needed
      await tester.scrollUntilVisible(
        find.text('Uji Kasus Konten Tidak Terdaftar'),
        100,
      );
      await tester.tap(find.text('Uji Kasus Konten Tidak Terdaftar'));
      await tester.pumpAndSettle();

      expect(selectedContent, contains('tidak terdaftar'));
    });
  });
}
