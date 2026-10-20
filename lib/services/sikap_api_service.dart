import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/fact_check_result.dart';
import 'auth_service.dart';
import 'fact_check_service.dart';

export 'auth_service.dart';

class SikapApiService implements AuthService, FactCheckService {
  SikapApiService({
    http.Client? client,
    TokenStorage? tokenStorage,
    Uri? baseUri,
  }) : _client = client ?? http.Client(),
       _tokenStorage = tokenStorage ?? SecureTokenStorage(),
       _baseUri = baseUri ?? _defaultBaseUri;

  static const _configuredBaseUrl = String.fromEnvironment('SIKAP_API_URL');
  static const _tokenHeader = 'Authorization';
  final http.Client _client;
  final TokenStorage _tokenStorage;
  final Uri _baseUri;

  static Uri get _defaultBaseUri {
    final configured = _configuredBaseUrl.trim();
    if (configured.isNotEmpty) return Uri.parse(configured);
    return Uri.parse(
      defaultTargetPlatform == TargetPlatform.android
          ? 'http://10.0.2.2:3000'
          : 'http://127.0.0.1:3000',
    );
  }

  @override
  Future<void> login(String identifier, String password) async {
    final body = await _request(
      'POST',
      '/api/auth/login',
      body: {'identifier': identifier.trim(), 'password': password},
    );
    final data = _map(body['data'], 'Respons login tidak valid.');
    final token = data['token'];
    if (token is! String || token.isEmpty) {
      throw const SikapApiException('Server tidak mengirim token sesi.');
    }
    await _tokenStorage.write(token);
  }

  Future<void> register(String name, String email, String password) async {
    await _request(
      'POST',
      '/api/auth/register',
      body: {'nama': name.trim(), 'email': email.trim(), 'password': password},
    );
  }

  @override
  Future<bool> restoreSession() async {
    final token = await _tokenStorage.read();
    if (token == null || token.isEmpty) return false;
    try {
      await _request('GET', '/api/auth/me', token: token);
      return true;
    } on _UnauthorizedException {
      await _tokenStorage.delete();
      return false;
    }
  }

  @override
  Future<void> logout() => _tokenStorage.delete();

  @override
  Future<FactCheckResult> analyze(String sharedContent) async {
    final payload = _analysisPayload(sharedContent);
    final Map<String, Object?> response;
    try {
      response = await _request('POST', '/api/analyze/guest', body: payload);
    } on SikapApiException catch (error) {
      throw FactCheckException(error.message);
    }

    if (response['status'] == 'IGNORED_NON_POLITICAL' &&
        response['trigger_toast'] == true &&
        response['is_political'] == false) {
      return FactCheckResult(
        verdict: FactCheckVerdict.notPolitical,
        isPolitical: false,
        claim: 'Konten bukan politik',
        summary: 'Tidak ada konten politik yang terdeteksi.',
        explanation: 'Konten berada di luar cakupan analisis politik SIKAP.',
        confidence: 0,
        sources: const [],
        triggerToast: true,
        toastMessage: response['toast_message'] is String
            ? response['toast_message'] as String
            : 'Tidak ada konten politik yang terdeteksi pada halaman ini.',
      );
    }

    final record = _map(response['data'], 'Hasil analisis tidak valid.');
    final analysis = _map(
      record['aiAnalysis'],
      'Detail analisis tidak tersedia.',
    );
    final political = analysis['is_political'];
    final badge = analysis['badge'];
    if (political != true || badge is! String) {
      throw const FactCheckException('Respons analisis tidak valid.');
    }

    final rawSources = analysis['fact_check_references'];
    final sources = rawSources is List
        ? rawSources.whereType<Map>().map((source) {
            final sourceMap = Map<Object?, Object?>.from(source);
            return FactCheckSource(
              title: sourceMap['source_name'] is String
                  ? sourceMap['source_name'] as String
                  : 'Sumber rujukan',
              url: sourceMap['url_or_description'] is String
                  ? sourceMap['url_or_description'] as String
                  : '',
            );
          }).toList()
        : const <FactCheckSource>[];

    return FactCheckResult(
      verdict: switch (badge) {
        'MERAH' => FactCheckVerdict.falseClaim,
        'KUNING' => FactCheckVerdict.uncertain,
        'HIJAU' => FactCheckVerdict.verifiedTrue,
        _ => throw const FactCheckException('Lencana analisis tidak dikenal.'),
      },
      isPolitical: true,
      claim: record['inputText'] is String && record['inputText'] != ''
          ? record['inputText'] as String
          : record['inputUrl'] is String
          ? record['inputUrl'] as String
          : 'Konten politik yang dianalisis',
      summary: _string(analysis['summary'], 'Ringkasan tidak tersedia.'),
      explanation: (analysis['key_findings'] is List)
          ? (analysis['key_findings'] as List).whereType<String>().join('\n')
          : _string(analysis['user_guidance'], 'Penjelasan tidak tersedia.'),
      confidence: analysis['confidence_score'] is num
          ? ((analysis['confidence_score'] as num) * 100).round()
          : 0,
      sources: sources,
    );
  }

  Map<String, Object?> _analysisPayload(String content) {
    final normalized = content.trim();
    final match = RegExp(r'https?://[^\s<>"\]]+').firstMatch(normalized);
    if (match == null) {
      if (normalized.length < 40) {
        throw const FactCheckException(
          'Teks klaim harus memiliki minimal 40 karakter.',
        );
      }
      return {'text': normalized};
    }

    final rawUrl = match.group(0)!.replaceFirst(RegExp(r'[.,!?;:)\]]+$'), '');
    final url = Uri.tryParse(rawUrl);
    if (url == null || !url.hasAuthority || url.host.isEmpty) {
      throw const FactCheckException('Tautan yang dimasukkan tidak valid.');
    }
    if (url.scheme != 'https') {
      throw const FactCheckException('Tautan harus menggunakan HTTPS.');
    }

    final context = normalized.replaceFirst(match.group(0)!, '').trim();
    return {if (context.length >= 40) 'text': context, 'url': url.toString()};
  }

  Future<Map<String, Object?>> _request(
    String method,
    String path, {
    Map<String, Object?>? body,
    String? token,
    bool rawUnauthorized = false,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null) headers[_tokenHeader] = 'Bearer $token';
    final http.Response response;
    try {
      final request = http.Request(method, _baseUri.resolve(path))
        ..headers.addAll(headers);
      if (body != null) request.body = jsonEncode(body);
      final streamed = await _client
          .send(request)
          .timeout(const Duration(seconds: 45));
      response = await http.Response.fromStream(streamed);
    } on TimeoutException {
      throw const SikapApiException(
        'Server membutuhkan waktu terlalu lama. Coba lagi nanti.',
      );
    } on http.ClientException catch (error) {
      throw SikapApiException('Tidak dapat menghubungi server SIKAP: $error');
    }

    final Map<String, Object?> decoded;
    try {
      final value = jsonDecode(response.body);
      if (value is! Map) {
        throw const FormatException('Respons server bukan objek JSON.');
      }
      decoded = Map<String, Object?>.from(value);
    } on FormatException {
      throw const SikapApiException(
        'Server mengirim respons yang tidak valid.',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = decoded['error'];
      final message = error is Map ? error['message'] : null;
      final details = error is Map ? error['details'] : null;
      final detailMessage = details is List && details.isNotEmpty
          ? (details.first is Map ? details.first['message'] : null)
          : null;
      if (response.statusCode == 401 && rawUnauthorized) {
        await _tokenStorage.delete();
        throw const FactCheckException(
          'Sesi login sudah berakhir. Silakan masuk kembali.',
        );
      }
      if (response.statusCode == 401) throw const _UnauthorizedException();
      throw SikapApiException(
        detailMessage is String && detailMessage.isNotEmpty
            ? detailMessage
            : message is String && message.isNotEmpty
            ? message
            : 'Server SIKAP gagal memproses permintaan (HTTP ${response.statusCode}).',
      );
    }
    return decoded;
  }

  Map<Object?, Object?> _map(Object? value, String errorMessage) {
    if (value is Map) return value;
    throw FactCheckException(errorMessage);
  }

  String _string(Object? value, String fallback) =>
      value is String && value.isNotEmpty ? value : fallback;

  void close() => _client.close();
}

class _UnauthorizedException implements Exception {
  const _UnauthorizedException();
}
