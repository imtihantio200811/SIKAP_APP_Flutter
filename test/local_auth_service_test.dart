import 'package:flutter_test/flutter_test.dart';
import 'package:sikap_project/services/local_auth_service.dart';
import 'package:sikap_project/services/sikap_api_service.dart';

void main() {
  test(
    'accepts local demo credentials and restores the local session',
    () async {
      final storage = _MemoryTokenStorage();
      final auth = LocalAuthService(storage: storage);

      await auth.login('admin123', 'admin123');

      expect(await auth.restoreSession(), isTrue);
      expect(storage.value, 'authenticated');
    },
  );

  test('rejects wrong local credentials without creating a session', () async {
    final storage = _MemoryTokenStorage();
    final auth = LocalAuthService(storage: storage);

    await expectLater(
      auth.login('admin123', 'wrong-password'),
      throwsA(isA<SikapApiException>()),
    );

    expect(await auth.restoreSession(), isFalse);
  });

  test('clears the local session on logout', () async {
    final storage = _MemoryTokenStorage();
    final auth = LocalAuthService(storage: storage);
    await auth.login('admin123', 'admin123');

    await auth.logout();

    expect(await auth.restoreSession(), isFalse);
  });
}

class _MemoryTokenStorage implements TokenStorage {
  String? value;

  @override
  Future<void> delete() async => value = null;

  @override
  Future<String?> read() async => value;

  @override
  Future<void> write(String token) async => value = token;
}
