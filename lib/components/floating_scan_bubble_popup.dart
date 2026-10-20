import 'package:flutter/material.dart';

import '../models/fact_check_result.dart';
import 'fact_check_presentation.dart';
import 'shield_pulse_painter.dart';

class FloatingScanBubblePopup extends StatelessWidget {
  const FloatingScanBubblePopup({
    super.key,
    required this.result,
    required this.isVisible,
    required this.toastMessage,
    required this.onBubbleTap,
    required this.onOpenFacts,
    required this.onCloseResult,
  });

  final FactCheckResult? result;
  final bool isVisible;
  final String? toastMessage;
  final VoidCallback onBubbleTap;
  final VoidCallback onOpenFacts;
  final VoidCallback onCloseResult;

  @override
  Widget build(BuildContext context) {
    if (isVisible && result != null) {
      return _ResultPopup(
        result: result!,
        onOpenFacts: onOpenFacts,
        onClose: onCloseResult,
      );
    }
    return _Bubble(toastMessage: toastMessage, onTap: onBubbleTap);
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.toastMessage, required this.onTap});

  final String? toastMessage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Semantics(
              label: 'Buka pemindai SIKAP',
              button: true,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9DDE2),
                    shape: BoxShape.circle,
                  ),
                  child: const CustomPaint(painter: ShieldPulsePainter()),
                ),
              ),
            ),
          ),
          if (toastMessage case final message?)
            Positioned(
              left: 72,
              child: Material(
                color: const Color(0xFF102A43),
                borderRadius: BorderRadius.circular(10),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ResultPopup extends StatelessWidget {
  const _ResultPopup({
    required this.result,
    required this.onOpenFacts,
    required this.onClose,
  });

  final FactCheckResult result;
  final VoidCallback onOpenFacts;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final color = FactCheckPresentation.color(result.verdict);
    final verdictLabel = FactCheckPresentation.label(result.verdict);
    final verdictIcon = FactCheckPresentation.icon(result.verdict);

    return Align(
      alignment: Alignment.centerLeft,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Material(
            color: Colors.white,
            elevation: 12,
            shadowColor: const Color(0x33000000),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 340),
              padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.shield_outlined,
                          color: color,
                          size: 15,
                        ),
                      ),
                      const SizedBox(width: 7),
                      const Expanded(
                        child: Text(
                          'Lencana SIKAP',
                          style: TextStyle(
                            color: Color(0xFF102A43),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Tutup hasil',
                        onPressed: onClose,
                        icon: const Icon(Icons.close, size: 17),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 26,
                          minHeight: 26,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(verdictIcon, color: color, size: 14),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            verdictLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: color,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (result.confidence > 0) ...[
                          const SizedBox(width: 6),
                          Text(
                            '${result.confidence}% yakin',
                            style: TextStyle(
                              color: color,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          result.summary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF34495E),
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 32,
                        child: FilledButton(
                          onPressed: onOpenFacts,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF123966),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 0,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Detail Fakta',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 3),
                              Icon(Icons.chevron_right, size: 14),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
