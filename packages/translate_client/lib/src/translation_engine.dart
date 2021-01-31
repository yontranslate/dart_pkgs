import 'models/look_up_request.dart';
import 'models/look_up_response.dart';
import 'models/translate_request.dart';
import 'models/translate_response.dart';

abstract class TranslationEngine {
  String get type;

  String identifier;
  String name;
  Map<String, dynamic> option;

  TranslationEngine({
    this.identifier,
    this.name,
    this.option,
  });

  Future<LookUpResponse> lookUp(LookUpRequest request);
  Future<TranslateResponse> translate(TranslateRequest request);

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'type': type,
      'name': name,
    };
  }
}
