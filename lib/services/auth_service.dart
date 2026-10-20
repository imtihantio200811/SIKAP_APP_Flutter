import 'package:flutter/services.dart';

abstract interface class AuthService {
  Future<void> login(String identifier, String password);
  Future<bool> restoreSession();
  Future<void> logout();
}

abstract interface class TokenStorage {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> delete();
}

class SecureTokenStorage implements TokenStorage {
  const SecureTokenStorage({this.key = _tokenKey});

  static const _channel = MethodChannel('com.sikap/secure_storage');
  static const _tokenKey = 'sikap_access_token';
  final String key;

  @override
  Future<String?> read() => _channel.invokeMethod<String>('read', {'key': key});

  @override
  Future<void> write(String token) =>
      _channel.invokeMethod<void>('write', {'key': key, 'value': token});

  @override
  Future<void> delete() => _channel.invokeMethod<void>('delete', {'key': key});
}

class SikapApiException implements Exception {
  const SikapApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
