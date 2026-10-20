import 'package:flutter/material.dart';

import 'components/authenticated_shell.dart';
import 'controllers/citizen_profile_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'controllers/fact_check_controller.dart';
import 'controllers/inspection_history_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/narrative_verification_controller.dart';
import 'controllers/permission_controller.dart';
import 'pages/login_page.dart';
import 'pages/onboarding_page.dart';
import 'pages/permission_page.dart';
import 'services/sikap_api_service.dart';

class SikapAppRoutes {
  const SikapAppRoutes({
    required this.loginController,
    required this.permissionController,
    required this.dashboardController,
    required this.narrativeVerificationController,
    required this.inspectionHistoryController,
    required this.citizenProfileController,
    required this.factCheckController,
    required this.authService,
    required this.onLogin,
    required this.onLocalLoginInfo,
  });

  final LoginController loginController;
  final PermissionController permissionController;
  final DashboardController dashboardController;
  final NarrativeVerificationController narrativeVerificationController;
  final InspectionHistoryController inspectionHistoryController;
  final CitizenProfileController citizenProfileController;
  final FactCheckController factCheckController;
  final AuthService authService;
  final ValueChanged<BuildContext> onLogin;
  final ValueChanged<BuildContext> onLocalLoginInfo;

  Map<String, WidgetBuilder> build() => {
    '/login': (context) => LoginPage(
      controller: loginController,
      onLogin: () => onLogin(context),
      onLocalLoginInfo: () => onLocalLoginInfo(context),
    ),
    '/onboarding': (context) => OnboardingPage(
      onSkip: () => Navigator.of(context).pushReplacementNamed('/permissions'),
      onContinue: () =>
          Navigator.of(context).pushReplacementNamed('/permissions'),
      onBack: () => Navigator.of(context).pushReplacementNamed('/login'),
    ),
    '/permissions': (context) => PermissionPage(
      controller: permissionController,
      onLater: () => Navigator.of(context).pushReplacementNamed('/dashboard'),
    ),
    '/dashboard': (context) => AuthenticatedShell(
      dashboardController: dashboardController,
      narrativeVerificationController: narrativeVerificationController,
      inspectionHistoryController: inspectionHistoryController,
      citizenProfileController: citizenProfileController,
      factCheckController: factCheckController,
      authService: authService,
    ),
  };
}
