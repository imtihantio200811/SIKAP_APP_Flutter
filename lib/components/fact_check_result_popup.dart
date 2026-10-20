import 'package:flutter/material.dart';

import '../models/fact_check_result.dart';
import 'fact_check_facts_panel.dart';
import 'fact_check_presentation.dart';

class FactCheckResultPopup extends StatelessWidget {
  const FactCheckResultPopup({
    super.key,
    required this.result,
    required this.onDismiss,
  });

  final FactCheckResult result;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: onDismiss,
              child: ColoredBox(color: Colors.black.withValues(alpha: 0.28)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: _ResultCard(
                  result: result,
                  onDismiss: onDismiss,
                  onOpenFacts: () => _showFacts(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFacts(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup detail fakta',
      barrierColor: Colors.black.withValues(alpha: 0.62),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FactCheckFactsPanel(result: result),
        ),
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.result,
    required this.onDismiss,
    required this.onOpenFacts,
  });

  final FactCheckResult result;
  final VoidCallback onDismiss;
  final VoidCallback onOpenFacts;

  @override
  Widget build(BuildContext context) {
    final color = FactCheckPresentation.color(result.verdict);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      elevation: 16,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.shield_outlined, color: color, size: 23),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lencana SIKAP',
                        style: TextStyle(
                          color: Color(0xFF102A43),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Hasil pemeriksaan konten',
                        style: TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Tutup hasil',
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close, size: 20),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    FactCheckPresentation.icon(result.verdict),
                    color: color,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      FactCheckPresentation.label(result.verdict),
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (result.confidence > 0)
                    Text(
                      '${result.confidence}% yakin',
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              result.summary,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF34495E),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: FilledButton(
                onPressed: onOpenFacts,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF123966),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Detail Fakta',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
