enum FactCheckVerdict {
  verifiedTrue,
  falseClaim,
  uncertain,
  notPolitical,
  insufficientContext,
  analysisError,
  notChecked,
}

class FactCheckSource {
  const FactCheckSource({required this.title, required this.url});

  final String title;
  final String url;

  Map<String, String> toMap() => {'title': title, 'url': url};

  factory FactCheckSource.fromMap(Map<Object?, Object?> map) {
    final title = map['title'];
    final url = map['url'];
    if (title is! String || url is! String) {
      throw const FormatException('Invalid fact-check source.');
    }
    return FactCheckSource(title: title, url: url);
  }
}

class FactCheckResult {
  const FactCheckResult.notChecked()
    : this(
        verdict: FactCheckVerdict.notChecked,
        isPolitical: false,
        claim: 'Belum ada konten yang dipindai.',
        summary: 'Belum ada hasil pemeriksaan.',
        explanation:
            'Pemindaian berita belum diaktifkan. Belum ada penilaian '
            'kebenaran atau sumber yang diperiksa.',
        confidence: 0,
        sources: const [],
      );

  const FactCheckResult({
    required this.verdict,
    required this.isPolitical,
    required this.claim,
    required this.summary,
    required this.explanation,
    required this.confidence,
    required this.sources,
    this.triggerToast = false,
    this.toastMessage,
  });

  final FactCheckVerdict verdict;
  final bool isPolitical;
  final String claim;
  final String summary;
  final String explanation;
  final int confidence;
  final List<FactCheckSource> sources;
  final bool triggerToast;
  final String? toastMessage;

  Map<String, Object?> toMap() => {
    'type': 'fact_check_result',
    'verdict': verdict.name,
    'isPolitical': isPolitical,
    'claim': claim,
    'summary': summary,
    'explanation': explanation,
    'confidence': confidence,
    'sources': sources.map((source) => source.toMap()).toList(),
    'triggerToast': triggerToast,
    'toastMessage': toastMessage,
  };

  factory FactCheckResult.fromMap(Map<Object?, Object?> map) {
    final verdictName = map['verdict'];
    final isPolitical = map['isPolitical'];
    final claim = map['claim'];
    final summary = map['summary'];
    final explanation = map['explanation'];
    final confidence = map['confidence'];
    final rawSources = map['sources'];
    final triggerToast = map['triggerToast'];
    final toastMessage = map['toastMessage'];

    if (verdictName is! String ||
        isPolitical is! bool ||
        claim is! String ||
        summary is! String ||
        explanation is! String ||
        confidence is! int ||
        (triggerToast != null && triggerToast is! bool) ||
        (toastMessage != null && toastMessage is! String) ||
        (rawSources != null && rawSources is! List)) {
      throw const FormatException('Invalid fact-check result.');
    }

    FactCheckVerdict? verdict;
    for (final candidate in FactCheckVerdict.values) {
      if (candidate.name == verdictName) {
        verdict = candidate;
        break;
      }
    }
    if (verdict == null) {
      throw const FormatException('Unknown fact-check verdict.');
    }
    if (confidence < 0 || confidence > 100) {
      throw const FormatException('Invalid confidence value.');
    }

    return FactCheckResult(
      verdict: verdict,
      isPolitical: isPolitical,
      claim: claim,
      summary: summary,
      explanation: explanation,
      confidence: confidence,
      triggerToast: triggerToast as bool? ?? false,
      toastMessage: toastMessage as String?,
      sources: (rawSources as List? ?? const []).map((source) {
        if (source is! Map) {
          throw const FormatException('Invalid fact-check source.');
        }
        return FactCheckSource.fromMap(source);
      }).toList(),
    );
  }
}
