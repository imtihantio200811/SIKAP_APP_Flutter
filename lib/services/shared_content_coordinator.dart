import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../controllers/fact_check_controller.dart';

class SharedContentCoordinator {
  SharedContentCoordinator({required this.factCheckController});

  static const _sharedContentChannel = MethodChannel(
    'com.sikap/shared_content',
  );
  static const _sharedContentEvents = EventChannel(
    'com.sikap/shared_content/events',
  );

  final FactCheckController factCheckController;

  StreamSubscription<dynamic> listen() {
    return _sharedContentEvents.receiveBroadcastStream().listen(
      (data) => unawaited(_handleSharedContent(data)),
      onError: _reportPlatformError,
    );
  }

  Future<void> readInitialSharedContent() async {
    try {
      final initial = await _sharedContentChannel
          .invokeMapMethod<String, String>('getInitialSharedContent');
      if (initial != null) await _handleSharedContent(initial);
    } on PlatformException catch (error, stackTrace) {
      _reportPlatformError(error, stackTrace);
    } on MissingPluginException catch (error, stackTrace) {
      _reportPlatformError(error, stackTrace);
    }
  }

  Future<void> _handleSharedContent(Object? data) async {
    if (data is! Map) return;
    final text = data['text'];
    final subject = data['subject'];
    final parts = [
      if (subject is String && subject.trim().isNotEmpty) subject.trim(),
      if (text is String && text.trim().isNotEmpty) text.trim(),
    ];
    if (parts.isEmpty) {
      await factCheckController.analyzeSharedContent('');
      await _returnScannerToMonitoring();
      return;
    }

    final useFloatingOverlay = await _beginFloatingOverlayScan();
    final result = await factCheckController.analyzeSharedContent(
      parts.toSet().join('\n'),
    );
    if (result == null) {
      await _returnScannerToMonitoring();
      return;
    }
    if (!useFloatingOverlay) return;

    try {
      await FlutterOverlayWindow.shareData(result.toMap());
      await Future<void>.delayed(const Duration(milliseconds: 350));
      await SystemNavigator.pop();
    } on PlatformException catch (error, stackTrace) {
      _reportPlatformError(error, stackTrace);
    } on MissingPluginException catch (error, stackTrace) {
      _reportPlatformError(error, stackTrace);
    }
  }

  Future<bool> _beginFloatingOverlayScan() async {
    if (kIsWeb || !Platform.isAndroid) return false;
    try {
      if (!await FlutterOverlayWindow.isActive()) return false;
      await FlutterOverlayWindow.shareData({'type': 'scan_loading'});
      return true;
    } on PlatformException catch (error, stackTrace) {
      _reportPlatformError(error, stackTrace);
    } on MissingPluginException catch (error, stackTrace) {
      _reportPlatformError(error, stackTrace);
    }
    return false;
  }

  Future<void> _returnScannerToMonitoring() async {
    if (kIsWeb || !Platform.isAndroid) return;
    try {
      if (await FlutterOverlayWindow.isActive()) {
        await FlutterOverlayWindow.shareData({'type': 'scan_ignored'});
        await Future<void>.delayed(const Duration(milliseconds: 350));
        await SystemNavigator.pop();
      }
    } on PlatformException catch (error, stackTrace) {
      _reportPlatformError(error, stackTrace);
    } on MissingPluginException catch (error, stackTrace) {
      _reportPlatformError(error, stackTrace);
    }
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
}
