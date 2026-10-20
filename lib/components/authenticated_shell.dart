import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/citizen_profile_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/fact_check_controller.dart';
import '../controllers/inspection_history_controller.dart';
import '../controllers/narrative_verification_controller.dart';
import '../services/sikap_api_service.dart';
import '../pages/citizen_profile_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/inspection_history_page.dart';
import '../pages/narrative_verification_page.dart';
import 'fact_check_result_overlay.dart';

class AuthenticatedShell extends StatefulWidget {
  const AuthenticatedShell({
    super.key,
    required this.dashboardController,
    required this.narrativeVerificationController,
    required this.inspectionHistoryController,
    required this.citizenProfileController,
    required this.factCheckController,
    required this.authService,
  });

  final DashboardController dashboardController;
  final NarrativeVerificationController narrativeVerificationController;
  final InspectionHistoryController inspectionHistoryController;
  final CitizenProfileController citizenProfileController;
  final FactCheckController factCheckController;
  final AuthService authService;

  @override
  State<AuthenticatedShell> createState() => _AuthenticatedShellState();
}

class _AuthenticatedShellState extends State<AuthenticatedShell> {
  int _selectedIndex = 0;

  void _selectNavigation(int index) {
    if (index == 2) {
      widget.citizenProfileController.toggleFloatingBubble(context);
      return;
    }
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final page = switch (_selectedIndex) {
      0 => DashboardPage(
        controller: widget.dashboardController,
        selectedNavigationIndex: _selectedIndex,
        onNavigationSelected: _selectNavigation,
      ),
      1 => NarrativeVerificationPage(
        controller: widget.narrativeVerificationController,
        selectedNavigationIndex: _selectedIndex,
        onNavigationSelected: _selectNavigation,
      ),
      3 => InspectionHistoryPage(
        controller: widget.inspectionHistoryController,
        selectedNavigationIndex: _selectedIndex,
        onNavigationSelected: _selectNavigation,
      ),
      4 => CitizenProfilePage(
        controller: widget.citizenProfileController,
        selectedNavigationIndex: _selectedIndex,
        onNavigationSelected: _selectNavigation,
        onLogout: () => unawaited(_logout()),
      ),
      _ => throw StateError(
        'Unsupported bottom navigation index: $_selectedIndex',
      ),
    };
    return Stack(
      fit: StackFit.expand,
      children: [
        page,
        FactCheckResultOverlay(controller: widget.factCheckController),
      ],
    );
  }

  Future<void> _logout() async {
    await widget.authService.logout();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    }
  }
}
