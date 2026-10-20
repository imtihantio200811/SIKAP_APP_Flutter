import 'package:flutter/material.dart';

import '../controllers/fact_check_controller.dart';
import 'floating_scan_bubble_loading_panel.dart';
import 'fact_check_result_popup.dart';

class FactCheckResultOverlay extends StatelessWidget {
  const FactCheckResultOverlay({super.key, required this.controller});

  final FactCheckController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        switch (controller.status) {
          case FactCheckStatus.idleMonitoring:
            return const SizedBox.shrink();
          case FactCheckStatus.loading:
            return const Positioned.fill(
              child: FloatingScanBubbleLoadingPanel(),
            );
          case FactCheckStatus.complete:
            final result = controller.result;
            if (result == null) return const SizedBox.shrink();
            return FactCheckResultPopup(
              result: result,
              onDismiss: controller.reset,
            );
        }
      },
    );
  }
}
