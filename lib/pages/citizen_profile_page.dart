import 'package:flutter/material.dart';

import '../components/citizen_profile_content.dart';
import '../components/dashboard_background.dart';
import '../components/dashboard_header.dart';
import '../components/dashboard_navigation.dart';
import '../controllers/citizen_profile_controller.dart';

class CitizenProfilePage extends StatelessWidget {
  const CitizenProfilePage({
    super.key,
    required this.controller,
    required this.selectedNavigationIndex,
    required this.onNavigationSelected,
    required this.onLogout,
  });

  final CitizenProfileController controller;
  final int selectedNavigationIndex;
  final ValueChanged<int> onNavigationSelected;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFF7FAFC),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final pageWidth = constraints.maxWidth;

              return Stack(
                children: [
                  const Positioned.fill(child: DashboardBackground()),
                  SizedBox(
                    width: pageWidth,
                    child: Column(
                      children: [
                        const DashboardHeader(),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(
                              bottom: 112 + MediaQuery.viewInsetsOf(context).bottom,
                            ),
                            child: CitizenProfileContent(
                              controller: controller,
                              onLogout: onLogout,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 30,
                    child: Center(
                      child: SizedBox(
                        width: pageWidth - 32,
                        child: DashboardNavigation(
                          selectedIndex: selectedNavigationIndex,
                          onSelect: onNavigationSelected,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
