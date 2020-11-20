import 'package:test/test.dart';

import 'package:translate_client/translate_client.dart';

void main() {
  test('adds one to input values', () {
    final client = TranslateClient([]);
    client.firstEngine.lookUp(LookUpRequest());
    client.firstEngine.translate(TranslateRequest());
  });
}
