import 'package:flutter/material.dart';

import '../components/dashboard_background.dart';
import '../components/dashboard_header.dart';
import '../components/dashboard_navigation.dart';
import '../components/inspection_history_content.dart';
import '../controllers/inspection_history_controller.dart';

class InspectionHistoryPage extends StatelessWidget {
  const InspectionHistoryPage({
    super.key,
    required this.controller,
    required this.selectedNavigationIndex,
    required this.onNavigationSelected,
  });

  final InspectionHistoryController controller;
  final int selectedNavigationIndex;
  final ValueChanged<int> onNavigationSelected;

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
                              bottom: 110 + MediaQuery.viewInsetsOf(context).bottom,
                            ),
                            child: InspectionHistoryContent(
                              controller: controller,
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
