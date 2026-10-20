import 'package:flutter/material.dart';

import '../components/permission_algorithm_card.dart';
import '../components/permission_background.dart';
import '../components/permission_header.dart';
import '../components/permission_modes.dart';
import '../components/permission_request_card.dart';
import '../controllers/permission_controller.dart';

class PermissionPage extends StatelessWidget {
  const PermissionPage({
    super.key,
    required this.controller,
    required this.onLater,
  });

  final PermissionController controller;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: LayoutBuilder(
            builder: (context, constraints) {
              final pageWidth = constraints.maxWidth < 402
                  ? constraints.maxWidth
                  : 402.0;

              return Stack(
                children: [
                  const Positioned.fill(child: PermissionBackground()),
                  Center(
                    child: SizedBox(
                      width: pageWidth,
                      child: SafeArea(
                        child: LayoutBuilder(
                          builder: (context, safeConstraints) {
                            return SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: safeConstraints.maxHeight,
                                ),
                                child: IntrinsicHeight(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      22,
                                      12,
                                      22,
                                      22,
                                    ),
                                    child: Column(
                                      children: [
                                        const PermissionHeader(),
                                        const SizedBox(height: 24),
                                        PermissionModes(
                                          dynamicScreenSelected:
                                              controller.dynamicScreenSelected,
                                          onSelect:
                                              controller.selectDynamicScreen,
                                        ),
                                        const SizedBox(height: 15),
                                        const PermissionAlgorithmCard(),
                                        const Spacer(),
                                        const SizedBox(height: 24),
                                        PermissionRequestCard(
                                          realTimeScanningEnabled: controller
                                              .realTimeScanningEnabled,
                                          onToggleRealTimeScanning:
                                              controller.toggleRealTimeScanning,
                                          onRequestAccess: () => controller
                                              .showPermissionDialog(context),
                                          onLater: onLater,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
