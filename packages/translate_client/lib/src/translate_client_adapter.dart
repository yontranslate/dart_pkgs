import 'translation_engine.dart';

class DefaultTranslateClientAdapter extends TranslateClientAdapter {
  final List<TranslationEngine> engines;

  DefaultTranslateClientAdapter(this.engines);

  TranslationEngine get first {
    return engines.first;
  }

  TranslationEngine use(String identifier) {
    return engines.firstWhere((e) => e.identifier == identifier);
  }
}

abstract class TranslateClientAdapter {
  TranslationEngine get first;
  TranslationEngine use(String identifier);
}
