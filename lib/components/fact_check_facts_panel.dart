import 'package:flutter/material.dart';

import '../models/fact_check_result.dart';
import 'fact_check_presentation.dart';

class FactCheckFactsPanel extends StatelessWidget {
  const FactCheckFactsPanel({super.key, required this.result});

  final FactCheckResult result;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            _DragHandle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 10),
              child: Row(
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
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                shrinkWrap: true,
                children: [
                  _VerdictSummary(result: result, color: color),
                  const SizedBox(height: 18),
                  _FactSection(
                    title: 'Klaim yang dibagikan',
                    text: result.claim,
                  ),
                  const SizedBox(height: 16),
                  _FactSection(title: 'Penjelasan', text: result.explanation),
                  if (result.confidence > 0) ...[
                    const SizedBox(height: 16),
                    Text('Keyakinan model: ${result.confidence}%'),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    'Sumber rujukan',
                    style: TextStyle(
                      color: Color(0xFF102A43),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _FactSources(sources: result.sources),
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
    );
  }
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFFD3DAE2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _VerdictSummary extends StatelessWidget {
  const _VerdictSummary({required this.result, required this.color});

  final FactCheckResult result;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(FactCheckPresentation.icon(result.verdict), color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FactCheckPresentation.label(result.verdict),
                  style: TextStyle(color: color, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  result.summary,
                  style: const TextStyle(color: Color(0xFF34495E), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FactSection extends StatelessWidget {
  const _FactSection({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(text),
      ],
    );
  }
}

class _FactSources extends StatelessWidget {
  const _FactSources({required this.sources});

  final List<FactCheckSource> sources;

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) {
      return const Text(
        'Tidak ada sumber rujukan yang dikembalikan untuk pemeriksaan ini.',
        style: TextStyle(color: Color(0xFF718096), fontSize: 13, height: 1.45),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final source in sources)
          Padding(
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
      ],
    );
  }
}
