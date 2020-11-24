import 'translate_engine.dart';

class TranslateClient {
  final List<TranslateEngine> engines;

  TranslateClient(this.engines);

  TranslateEngine get firstEngine {
    return engines.first;
  }

  TranslateEngine use(String name) {
    return engines.firstWhere((e) => e.name == name);
  }
}
