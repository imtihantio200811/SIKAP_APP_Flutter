import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sikap_project/models/fact_check_result.dart';
import 'package:sikap_project/services/fact_check_service.dart';
import 'package:sikap_project/services/sikap_api_service.dart';

void main() {
  test('maps an analysis response without requiring an API login', () async {
    final service = SikapApiService(
      baseUri: Uri.parse('http://localhost:3000'),
      client: MockClient((request) async {
        expect(request.url.path, '/api/analyze/guest');
        expect(request.headers.containsKey('authorization'), isFalse);
        expect(jsonDecode(request.body), {
          'text': 'Klaim politik yang cukup panjang untuk dianalisis.',
        });
        return http.Response(
          jsonEncode({
            'data': {
              'inputText': 'Klaim politik yang cukup panjang untuk dianalisis.',
              'inputUrl': null,
              'aiAnalysis': {
                'badge': 'MERAH',
                'is_political': true,
                'summary': 'Klaim tidak didukung bukti.',
                'key_findings': ['Dokumen sumber membantah klaim.'],
                'confidence_score': 0.91,
                'fact_check_references': [
                  {
                    'source_name': 'Lembaga resmi',
                    'url_or_description': 'https://example.com/fakta',
                  },
                ],
              },
            },
          }),
          200,
        );
      }),
    );
    addTearDown(service.close);

    final result = await service.analyze(
      'Klaim politik yang cukup panjang untuk dianalisis.',
    );

    expect(result.verdict, FactCheckVerdict.falseClaim);
    expect(result.confidence, 91);
    expect(result.sources.single.title, 'Lembaga resmi');
  });

  test('maps an ignored non-political response to toast state', () async {
    final service = SikapApiService(
      baseUri: Uri.parse('http://localhost:3000'),
      client: MockClient((request) async {
        expect(request.url.path, '/api/analyze/guest');
        return http.Response(
          jsonEncode({
            'status': 'IGNORED_NON_POLITICAL',
            'is_political': false,
            'trigger_toast': true,
            'toast_message': 'Tidak ada konten politik pada halaman ini.',
            'data': null,
          }),
          200,
        );
      }),
    );
    addTearDown(service.close);

    final result = await service.analyze(
      'Berita hiburan biasa yang tidak membahas politik sama sekali.',
    );

    expect(result.isPolitical, isFalse);
    expect(result.triggerToast, isTrue);
    expect(result.toastMessage, 'Tidak ada konten politik pada halaman ini.');
  });

  test('sends a pasted HTTPS link as URL analysis input', () async {
    final service = SikapApiService(
      baseUri: Uri.parse('http://localhost:3000'),
      client: MockClient((request) async {
        expect(jsonDecode(request.body), {
          'url': 'https://example.com/politics',
        });
        return http.Response(
          jsonEncode({
            'data': {
              'inputText': null,
              'inputUrl': 'https://example.com/politics',
              'aiAnalysis': {
                'badge': 'KUNING',
                'is_political': true,
                'summary': 'Konteks belum cukup.',
                'key_findings': ['Periksa sumber primer.'],
                'confidence_score': 0.5,
                'fact_check_references': [],
              },
            },
          }),
          200,
        );
      }),
    );
    addTearDown(service.close);

    final result = await service.analyze('https://example.com/politics');

    expect(result.verdict, FactCheckVerdict.uncertain);
    expect(result.claim, 'https://example.com/politics');
  });

  test('keeps a sufficiently long shared caption with its URL', () async {
    const caption =
        'Klaim politik ini memiliki konteks yang cukup panjang untuk diperiksa.';
    final service = SikapApiService(
      baseUri: Uri.parse('http://localhost:3000'),
      client: MockClient((request) async {
        expect(jsonDecode(request.body), {
          'text': caption,
          'url': 'https://example.com/politics',
        });
        return http.Response(
          jsonEncode({
            'data': {
              'inputText': caption,
              'inputUrl': 'https://example.com/politics',
              'aiAnalysis': {
                'badge': 'HIJAU',
                'is_political': true,
                'summary': 'Klaim didukung bukti.',
                'key_findings': ['Sumber resmi mendukung klaim.'],
                'confidence_score': 0.9,
                'fact_check_references': [],
              },
            },
          }),
          200,
        );
      }),
    );
    addTearDown(service.close);

    await service.analyze('$caption https://example.com/politics');
  });

  test('rejects short plain text before making a request', () async {
    final service = SikapApiService(
      baseUri: Uri.parse('http://localhost:3000'),
      client: MockClient((_) async {
        fail('Short text must be rejected before making an HTTP request.');
      }),
    );
    addTearDown(service.close);

    await expectLater(
      service.analyze('Klaim pendek.'),
      throwsA(
        isA<FactCheckException>().having(
          (error) => error.message,
          'message',
          contains('minimal 40 karakter'),
        ),
      ),
    );
  });

  test('converts API failures into a fact-check result error', () async {
    final service = SikapApiService(
      baseUri: Uri.parse('http://localhost:3000'),
      client: MockClient((_) async {
        return http.Response(
          jsonEncode({
            'error': {
              'code': 'AI_REQUEST_FAILED',
              'message': 'Gemini tidak dapat menyelesaikan analisis konten.',
            },
          }),
          502,
        );
      }),
    );
    addTearDown(service.close);

    await expectLater(
      service.analyze('Klaim politik yang cukup panjang untuk dianalisis.'),
      throwsA(
        isA<FactCheckException>().having(
          (error) => error.message,
          'message',
          contains('Gemini tidak dapat menyelesaikan'),
        ),
      ),
    );
  });
}
