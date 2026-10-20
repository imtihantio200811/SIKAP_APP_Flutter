import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../models/demo_fact_check_data.dart';
import '../models/fact_check_result.dart';
import 'floating_scan_bubble_facts_panel.dart';
import 'floating_scan_bubble_loading_panel.dart';
import 'floating_scan_bubble_popup.dart';

class FloatingScanBubble extends StatefulWidget {
  const FloatingScanBubble({
    super.key,
    this.messageStream,
    this.fallbackResults,
  });

  final Stream<Object?>? messageStream;
  final List<FactCheckResult>? fallbackResults;

  @override
  State<FloatingScanBubble> createState() => _FloatingScanBubbleState();
}

class _FloatingScanBubbleState extends State<FloatingScanBubble> {
  StreamSubscription<dynamic>? _messages;
  FactCheckResult? _result;
  bool _isLoading = false;
  bool _previewOnly = false;
  bool _resultVisible = false;
  bool _factsOpen = false;
  bool _panelVisible = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _messages = (widget.messageStream ?? FlutterOverlayWindow.overlayListener)
        .listen(
          (message) => unawaited(_handleMessage(message)),
          onError: (Object error, StackTrace stackTrace) {
            FlutterError.reportError(
              FlutterErrorDetails(
                exception: error,
                stack: stackTrace,
                library: 'SIKAP overlay',
                context: ErrorDescription(
                  'while receiving a fact-check result',
                ),
              ),
            );
          },
        );
  }

  @override
  void dispose() {
    _messages?.cancel();
    super.dispose();
  }

  static const int _bubbleSize = 72;
  static const double _landscapeHeight = 160.0;

  Size _getLandscapeOverlaySize() {
    double screenWidth = 360.0;
    try {
      final view = View.maybeOf(context);
      if (view != null) {
        final display = view.display;
        final dpr = display.devicePixelRatio > 0
            ? display.devicePixelRatio
            : view.devicePixelRatio;
        if (display.size.width > 0 && dpr > 0) {
          screenWidth = display.size.width / dpr;
        }
      }
    } catch (_) {}

    final mediaWidth = MediaQuery.sizeOf(context).width;
    if (mediaWidth > 150 && mediaWidth < screenWidth) {
      screenWidth = mediaWidth;
    }

    // Lebar tidak memenuhi seluruh layar HP (diberikan space kosong di sisi layar)
    final targetWidth = (screenWidth * 0.86).clamp(300.0, 336.0);
    // Tinggi dibuat ringkas agar rasio jendela menjadi landscape (~2:1)
    return Size(targetWidth, _landscapeHeight);
  }

  Future<void> _handleMessage(Object? message) async {
    if (message is! Map) return;
    if (message['type'] == 'scan_ignored') {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _previewOnly = false;
        _result = null;
        _resultVisible = false;
        _factsOpen = false;
        _panelVisible = false;
      });
      await _resizeOverlay(_bubbleSize, _bubbleSize);
      return;
    }
    if (message['type'] == 'scan_loading') {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
        _previewOnly = false;
        _result = null;
        _resultVisible = false;
        _factsOpen = false;
        _panelVisible = false;
      });
      await _resizeToFullScreen();
      return;
    }
    if (message['type'] != 'fact_check_result') return;

    final result = FactCheckResult.fromMap(message);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _result = result;
      _resultVisible = true;
      _factsOpen = false;
    });
    final size = _getLandscapeOverlaySize();
    await _resizeOverlay(size.width.round(), size.height.round());
  }

  int _simulationIndex = 0;

  Future<void> _handleBubbleTap() async {
    if (_busy || _isLoading) return;

    final fallbackList = widget.fallbackResults ??
        [
          registeredDemoContents[0].result, // 1. Hoaks AI Deepfake (Merah)
          registeredDemoContents[1].result, // 2. Fakta Valid KPU (Hijau)
        ];
    final selectedResult = fallbackList[_simulationIndex % fallbackList.length];
    _simulationIndex++;

    setState(() {
      _busy = true;
      _isLoading = true;
      _previewOnly = false;
      _resultVisible = false;
      _result = selectedResult;
    });
    await _resizeToFullScreen();
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _previewOnly = false;
      _resultVisible = true;
    });
    final size = _getLandscapeOverlaySize();
    await _resizeOverlay(size.width.round(), size.height.round());
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _openFacts() async {
    if (_busy || _result == null) return;
    setState(() => _busy = true);
    await _resizeToFullScreen();
    if (!mounted) return;
    setState(() {
      _factsOpen = true;
      _panelVisible = true;
      _busy = false;
    });
  }

  Future<void> _closeFacts() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _panelVisible = false;
    });
    await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;
    setState(() => _factsOpen = false);
    final size = _getLandscapeOverlaySize();
    await _resizeOverlay(
      _resultVisible ? size.width.round() : _bubbleSize,
      _resultVisible ? size.height.round() : _bubbleSize,
    );
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _closeResult() async {
    setState(() => _resultVisible = false);
    await _resizeOverlay(_bubbleSize, _bubbleSize);
  }

  Future<void> _resizeToFullScreen() async {
    try {
      final resized = await FlutterOverlayWindow.resizeOverlay(
        WindowSize.matchParent,
        WindowSize.matchParent,
        false,
      );
      if (resized == false) _reportResizeFailure();
    } on MissingPluginException {
      _reportResizeFailure();
    } on PlatformException {
      _reportResizeFailure();
    }
  }

  Future<void> _resizeOverlay(int width, int height) async {
    try {
      final ratio = MediaQuery.devicePixelRatioOf(context);
      final resized = await FlutterOverlayWindow.resizeOverlay(
        (width * ratio).round(),
        (height * ratio).round(),
        false,
      );
      if (resized == false) _reportResizeFailure();
    } on MissingPluginException {
      _reportResizeFailure();
    } on PlatformException {
      _reportResizeFailure();
    }
  }

  Future<void> _closeOverlay() async {
    final closed = await FlutterOverlayWindow.closeOverlay();
    if (closed == false) _reportResizeFailure();
  }

  void _reportResizeFailure() {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: StateError('SIKAP floating overlay could not be resized.'),
        library: 'SIKAP overlay',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.transparent,
      home: PopScope<void>(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          if (_factsOpen) {
            unawaited(_closeFacts());
          } else {
            unawaited(_closeOverlay());
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _isLoading
              ? FloatingScanBubbleLoadingPanel(previewOnly: _previewOnly)
              : _factsOpen
              ? _buildFactsPanel()
              : FloatingScanBubblePopup(
                  result: _result,
                  isVisible: _resultVisible,
                  toastMessage: null,
                  onBubbleTap: _handleBubbleTap,
                  onOpenFacts: _openFacts,
                  onCloseResult: _closeResult,
                ),
        ),
      ),
    );
  }

  Widget _buildFactsPanel() {
    final result = _result;
    if (result == null) return const SizedBox.shrink();
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: _panelVisible ? 1 : 0,
            duration: const Duration(milliseconds: 220),
            child: GestureDetector(
              onTap: _closeFacts,
              child: ColoredBox(color: Colors.black.withValues(alpha: 0.58)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            top: false,
            child: AnimatedSlide(
              offset: _panelVisible ? Offset.zero : const Offset(0, 0.16),
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: _panelVisible ? 1 : 0,
                duration: const Duration(milliseconds: 220),
                child: GestureDetector(
                  onTap: () {},
                  child: FloatingScanBubbleFactsPanel(
                    result: result,
                    onClose: _closeFacts,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
