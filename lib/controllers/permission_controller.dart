import 'package:flutter/material.dart';

import '../components/permission_dialog.dart';

class PermissionController extends ChangeNotifier {
  bool _realTimeScanningEnabled = true;
  bool _overlayEnabled = true;
  bool _dynamicScreenSelected = false;

  bool get realTimeScanningEnabled => _realTimeScanningEnabled;
  bool get overlayEnabled => _overlayEnabled;
  bool get dynamicScreenSelected => _dynamicScreenSelected;

  void toggleRealTimeScanning() {
    _realTimeScanningEnabled = !_realTimeScanningEnabled;
    notifyListeners();
  }

  void toggleOverlay() {
    _overlayEnabled = !_overlayEnabled;
    notifyListeners();
  }

  void selectDynamicScreen(bool selected) {
    _dynamicScreenSelected = selected;
    notifyListeners();
  }

  Future<void> showPermissionDialog(BuildContext context) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup izin akses layar',
      barrierColor: const Color(0xB3000000),
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, animation, secondaryAnimation) {
        return PermissionDialog(
          animation: this,
          overlayEnabled: () => overlayEnabled,
          onToggleOverlay: toggleOverlay,
          onOpenSettings: () => closeDialog(context),
          onLater: () => closeDialog(context),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.18),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  void closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
