import 'translation_engine.dart';

class TranslateClient {
  final List<TranslationEngine> engines;

  TranslateClient(this.engines);

  TranslationEngine get firstEngine {
    return engines.first;
  }

  TranslationEngine use(String identifier) {
    return engines.firstWhere((e) => e.identifier == identifier);
  }
}
