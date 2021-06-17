import 'translation_engine.dart';
import 'translate_client_adapter.dart';

class TranslateClient {
  final TranslateClientAdapter adapter;

  TranslateClient(this.adapter);

  TranslationEngine get firstEngine {
    return adapter.first;
  }

  TranslationEngine use(String identifier) {
    return adapter.use(identifier);
  }
}
