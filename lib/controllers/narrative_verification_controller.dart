import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NarrativeVerificationController extends ChangeNotifier {
  NarrativeVerificationController({
    required this.onVerify,
    required this.onValidationError,
  });

  final linkController = TextEditingController();
  final Future<void> Function(String content) onVerify;
  final void Function(String message) onValidationError;
  bool _isAnalyzing = false;

  bool get isAnalyzing => _isAnalyzing;

  Future<void> pasteLink() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboardData?.text?.trim();
    if (text == null || text.isEmpty) return;

    linkController.text = text;
    notifyListeners();
  }

  Future<void> verifyLink() async {
    if (_isAnalyzing) return;
    final content = linkController.text.trim();
    if (content.isEmpty) {
      onValidationError('Tempel tautan HTTPS atau masukkan teks klaim.');
      return;
    }
    _isAnalyzing = true;
    notifyListeners();
    try {
      await onVerify(content);
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  Future<void> verifyContent(String content) async {
    linkController.text = content;
    notifyListeners();
    await verifyLink();
  }

  @override
  void dispose() {
    linkController.dispose();
    super.dispose();
  }
}
