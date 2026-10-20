import '../models/fact_check_result.dart';

abstract interface class FactCheckService {
  Future<FactCheckResult> analyze(String sharedContent);
}

class FactCheckException implements Exception {
  const FactCheckException(this.message);

  final String message;

  @override
  String toString() => message;
}
