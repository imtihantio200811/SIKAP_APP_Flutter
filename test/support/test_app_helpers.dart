import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sikap_project/main.dart';
import 'package:sikap_project/models/fact_check_result.dart';
import 'package:sikap_project/services/auth_service.dart';
import 'package:sikap_project/services/fact_check_service.dart';
import 'package:sikap_project/services/local_auth_service.dart';

Future<void> pumpPhoneApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(402, 874);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    SikapApp(
      factCheckService: FakeFactCheckService(),
      authService: LocalAuthService(storage: MemoryTokenStorage()),
    ),
  );
}

void mockOverlayResize() {
  const channel = MethodChannel('x-slayer/overlay');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'resizeOverlay') return true;
        return null;
      });
  addTearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null),
  );
}

class FakeFactCheckService implements FactCheckService {
  @override
  Future<FactCheckResult> analyze(String sharedContent) async {
    return const FactCheckResult(
      verdict: FactCheckVerdict.verifiedTrue,
      isPolitical: true,
      claim: 'Klaim politik yang dibagikan.',
      summary: 'Klaim didukung sumber yang tersedia.',
      explanation: 'Sumber resmi mengonfirmasi informasi.',
      confidence: 90,
      sources: [],
    );
  }
}

class MemoryTokenStorage implements TokenStorage {
  String? _value;

  @override
  Future<void> delete() async => _value = null;

  @override
  Future<String?> read() async => _value;

  @override
  Future<void> write(String token) async => _value = token;
}
