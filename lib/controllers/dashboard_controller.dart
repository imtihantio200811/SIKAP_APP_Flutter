import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fact_check_controller.dart';

class DashboardController extends ChangeNotifier {
  DashboardController(this._factCheckController);

  final FactCheckController _factCheckController;
  final linkController = TextEditingController();

  Future<void> pasteLink() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboardData?.text?.trim();
    if (text == null || text.isEmpty) return;
    linkController.text = text;
    notifyListeners();
  }

  Future<void> analyzeContent(BuildContext context, String content) async {
    linkController.text = content;
    notifyListeners();
    await checkLink(context);
  }

  Future<void> checkLink(BuildContext context) async {
    if (_factCheckController.status == FactCheckStatus.loading) return;
    final content = linkController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Masukkan teks atau tautan untuk dicek.'),
          ),
        );
      return;
    }
    await _factCheckController.analyzeSharedContent(content);
  }

  @override
  void dispose() {
    linkController.dispose();
    super.dispose();
  }
}
