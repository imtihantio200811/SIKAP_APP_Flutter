import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class CitizenProfileController extends ChangeNotifier {
  bool _floatingWidgetEnabled = true;
  bool _earlyWarningEnabled = true;
  int _sensitivityIndex = 2;
  bool _isLaunchingOverlay = false;

  static const sensitivityLevels = [
    'Rendah (Klaim Berisiko)',
    'Sedang (Seimbang)',
    'Tinggi (Klaim Agresif)',
  ];

  bool get floatingWidgetEnabled => _floatingWidgetEnabled;
  bool get earlyWarningEnabled => _earlyWarningEnabled;
  int get sensitivityIndex => _sensitivityIndex;
  String get sensitivity => sensitivityLevels[_sensitivityIndex];

  void toggleFloatingWidget() {
    _floatingWidgetEnabled = !_floatingWidgetEnabled;
    notifyListeners();
  }

  void toggleEarlyWarning() {
    _earlyWarningEnabled = !_earlyWarningEnabled;
    notifyListeners();
  }

  void cycleSensitivity() {
    _sensitivityIndex = (_sensitivityIndex + 1) % sensitivityLevels.length;
    notifyListeners();
  }

  Future<void> toggleFloatingBubble(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final overlayWindowSize = (72 * MediaQuery.devicePixelRatioOf(context))
        .round();
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      _showMessage(
        messenger,
        'Gelembung pemindai hanya tersedia pada perangkat Android.',
      );
      return;
    }
    if (_isLaunchingOverlay) return;

    _isLaunchingOverlay = true;
    try {
      if (await FlutterOverlayWindow.isActive()) {
        await FlutterOverlayWindow.closeOverlay();
        _showMessage(messenger, 'Gelembung pemindai dinonaktifkan.');
        return;
      }

      var permissionGranted = await FlutterOverlayWindow.isPermissionGranted();
      if (!permissionGranted) {
        permissionGranted =
            await FlutterOverlayWindow.requestPermission() ?? false;
      }

      if (!permissionGranted) {
        _showMessage(
          messenger,
          'Izinkan SIKAP tampil di atas aplikasi lain untuk mengaktifkan '
          'gelembung pemindai.',
        );
        return;
      }

      await FlutterOverlayWindow.showOverlay(
        height: overlayWindowSize,
        width: overlayWindowSize,
        alignment: OverlayAlignment.centerLeft,
        overlayTitle: 'SIKAP • Pemindai aktif',
        overlayContent: 'Ketuk gelembung untuk menutup pemindai.',
        enableDrag: false,
      );
    } on PlatformException catch (error) {
      _showMessage(
        messenger,
        'Gelembung pemindai gagal ditampilkan: '
        '${error.message ?? error.code}.',
      );
    } finally {
      _isLaunchingOverlay = false;
    }
  }

  void _showMessage(ScaffoldMessengerState messenger, String message) {
    if (!messenger.mounted) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
