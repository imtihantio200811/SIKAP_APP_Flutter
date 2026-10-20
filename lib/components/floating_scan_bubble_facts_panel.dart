import 'package:flutter/material.dart';

import '../models/fact_check_result.dart';
import 'fact_check_presentation.dart';

class FloatingScanBubbleFactsPanel extends StatelessWidget {
  const FloatingScanBubbleFactsPanel({
    super.key,
    required this.result,
    required this.onClose,
  });

  final FactCheckResult result;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final color = FactCheckPresentation.color(result.verdict);
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.82,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Detail Fakta',
                      style: TextStyle(
                        color: Color(0xFF102A43),
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Kembali',
                    onPressed: onClose,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      FactCheckPresentation.label(result.verdict),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(result.summary),
                    const SizedBox(height: 14),
                    const Text(
                      'Klaim yang dibagikan',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(result.claim),
                    const SizedBox(height: 14),
                    const Text(
                      'Penjelasan',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 5),
                    Text(result.explanation),
                    const SizedBox(height: 14),
                    if (result.confidence > 0)
                      Text('Keyakinan model: ${result.confidence}%'),
                    const SizedBox(height: 18),
                    const Text(
                      'Sumber rujukan',
                      style: TextStyle(
                        color: Color(0xFF102A43),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (result.sources.isEmpty)
                      const Text(
                        'Belum ada sumber rujukan karena konten belum dipindai.',
                        style: TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 13,
                          height: 1.45,
                        ),
                      )
                    else
                      ...result.sources.map(
                        (source) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.open_in_new,
                                size: 16,
                                color: Color(0xFF2878B8),
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      source.title,
                                      style: const TextStyle(
                                        color: Color(0xFF2878B8),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    SelectableText(
                                      source.url,
                                      style: const TextStyle(
                                        color: Color(0xFF718096),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    const Text(
                      'Hasil AI adalah bantuan informasi, bukan kepastian '
                      'mutlak. Periksa sumber dan konteks sebelum membagikan.',
                      style: TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 11,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
