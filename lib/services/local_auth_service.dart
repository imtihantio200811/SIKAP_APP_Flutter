import 'package:flutter/foundation.dart';

import 'sikap_api_service.dart';

class LocalAuthService implements AuthService {
  LocalAuthService({TokenStorage? storage})
    : _storage = storage ?? _defaultStorage();

  static const username = 'admin123';
  static const password = 'admin123';
  static const _sessionValue = 'authenticated';

  final TokenStorage _storage;

  static TokenStorage _defaultStorage() =>
      defaultTargetPlatform == TargetPlatform.android
      ? const SecureTokenStorage(key: 'sikap_local_login_session')
      : _MemoryTokenStorage();

  @override
  Future<void> login(String identifier, String password) async {
    if (identifier.trim() != username ||
        password != LocalAuthService.password) {
      throw const SikapApiException('Username atau kata sandi salah.');
    }
    await _storage.write(_sessionValue);
  }

  @override
  Future<bool> restoreSession() async => await _storage.read() == _sessionValue;

  @override
  Future<void> logout() => _storage.delete();
}

class _MemoryTokenStorage implements TokenStorage {
  String? _value;

  @override
  Future<void> delete() async => _value = null;

  @override
  Future<String?> read() async => _value;

  @override
  Future<void> write(String token) async => _value = token;
}
