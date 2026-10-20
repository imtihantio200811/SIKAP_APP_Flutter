import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_routes.dart';
import 'components/floating_scan_bubble.dart';
import 'controllers/citizen_profile_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'controllers/fact_check_controller.dart';
import 'controllers/inspection_history_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/narrative_verification_controller.dart';
import 'controllers/permission_controller.dart';
import 'services/fact_check_service.dart';
import 'services/local_auth_service.dart';
import 'services/local_fact_check_service.dart';
import 'services/shared_content_coordinator.dart';
import 'services/sikap_api_service.dart';

void main() {
  runApp(const SikapApp());
}

@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FloatingScanBubble());
}

class SikapApp extends StatefulWidget {
  const SikapApp({super.key, this.factCheckService, this.authService});

  final FactCheckService? factCheckService;
  final AuthService? authService;

  @override
  State<SikapApp> createState() => _SikapAppState();
}

class _SikapAppState extends State<SikapApp> {
  static const _systemToastChannel = MethodChannel('com.sikap/system_toast');
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  late final LoginController _loginController;
  late final PermissionController _permissionController;
  late final FactCheckController _factCheckController;
  late final AuthService _authService;
  late final DashboardController _dashboardController;
  late final NarrativeVerificationController _narrativeVerificationController;
  late final InspectionHistoryController _inspectionHistoryController;
  late final CitizenProfileController _citizenProfileController;
  late final SharedContentCoordinator _sharedContentCoordinator;
  SikapApiService? _ownedApiService;
  StreamSubscription<dynamic>? _sharedContentSubscription;

  @override
  void initState() {
    super.initState();
    _loginController = LoginController();
    _permissionController = PermissionController();
    final apiService = SikapApiService();
    _ownedApiService = apiService;
    _authService = widget.authService ?? LocalAuthService();
    final service = widget.factCheckService ?? const LocalFactCheckService();
    _factCheckController = FactCheckController(service, onToast: _showToast);
    _dashboardController = DashboardController(_factCheckController);
    _narrativeVerificationController = NarrativeVerificationController(
      onVerify: (content) async {
        await _factCheckController.analyzeSharedContent(content);
      },
      onValidationError: _showToast,
    );
    _inspectionHistoryController = InspectionHistoryController();
    _citizenProfileController = CitizenProfileController();
    _sharedContentCoordinator = SharedContentCoordinator(
      factCheckController: _factCheckController,
    );

    if (!kIsWeb && Platform.isAndroid) {
      _sharedContentSubscription = _sharedContentCoordinator.listen();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_sharedContentCoordinator.readInitialSharedContent());
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_restoreSession());
    });
  }

  @override
  void dispose() {
    _sharedContentSubscription?.cancel();
    _ownedApiService?.close();
    _dashboardController.dispose();
    _factCheckController.dispose();
    _narrativeVerificationController.dispose();
    _inspectionHistoryController.dispose();
    _citizenProfileController.dispose();
    _loginController.dispose();
    _permissionController.dispose();
    super.dispose();
  }

  Future<void> _restoreSession() async {
    try {
      if (await _authService.restoreSession() && mounted) {
        _navigatorKey.currentState!.pushReplacementNamed('/dashboard');
      }
    } on SikapApiException catch (error) {
      if (mounted) _showToast(error.message);
    } on PlatformException catch (error) {
      if (mounted) {
        _showToast(
          'Sesi lokal tidak dapat dibaca: ${error.message ?? error.code}.',
        );
      }
    }
  }

  Future<void> _handleLogin(BuildContext loginContext) async {
    final identifier = _loginController.usernameController.text.trim();
    final password = _loginController.passwordController.text;
    if (identifier.isEmpty || password.isEmpty) {
      _showToast('Masukkan username dan kata sandi untuk lanjut.');
      return;
    }
    try {
      await _authService.login(identifier, password);
      if (loginContext.mounted) {
        Navigator.of(loginContext).pushReplacementNamed('/onboarding');
      }
    } on SikapApiException catch (error) {
      if (loginContext.mounted) _showToast(error.message);
    } on PlatformException catch (error) {
      if (loginContext.mounted) {
        _showToast(
          'Login lokal gagal disimpan: ${error.message ?? error.code}.',
        );
      }
    }
  }

  void _showLocalLoginInfo(BuildContext dialogParent) {
    showDialog<void>(
      context: dialogParent,
      builder: (context) => AlertDialog(
        title: const Text('Akun lokal SIKAP'),
        content: const Text(
          'Gunakan username admin123 dan kata sandi admin123. '
          'Akun ini hanya untuk penggunaan lokal/demo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showToast(String message) {
    unawaited(_showSystemToast(message));
  }

  Future<void> _showSystemToast(String message) async {
    if (!kIsWeb && Platform.isAndroid) {
      try {
        await _systemToastChannel.invokeMethod<void>('showToast', {
          'message': message,
        });
        return;
      } on MissingPluginException {
        // Fall back to the app messenger if the platform channel is unavailable.
      } on PlatformException catch (error, stackTrace) {
        _reportPlatformError(error, stackTrace);
      }
    }
    _scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _reportPlatformError(Object error, StackTrace stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'SIKAP Android Share',
        context: ErrorDescription('while receiving or forwarding shared text'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      title: 'SIKAP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF123966),
          primary: const Color(0xFF123966),
        ),
      ),
      initialRoute: '/login',
      routes: SikapAppRoutes(
        loginController: _loginController,
        permissionController: _permissionController,
        dashboardController: _dashboardController,
        narrativeVerificationController: _narrativeVerificationController,
        inspectionHistoryController: _inspectionHistoryController,
        citizenProfileController: _citizenProfileController,
        factCheckController: _factCheckController,
        authService: _authService,
        onLogin: (context) => unawaited(_handleLogin(context)),
        onLocalLoginInfo: _showLocalLoginInfo,
      ).build(),
    );
  }
}
