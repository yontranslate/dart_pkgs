import 'models/look_up_request.dart';
import 'models/look_up_response.dart';
import 'models/translate_request.dart';
import 'models/translate_response.dart';

class TranslationEngineConfig {
  final String identifier;
  String type;
  String name;
  Map<String, dynamic> option;

  String get shortId => identifier.substring(0, 4);

  TranslationEngineConfig({
    this.identifier,
    this.type,
    this.name,
    this.option,
  });

  factory TranslationEngineConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return TranslationEngineConfig(
      identifier: json['identifier'],
      type: json['type'],
      name: json['name'],
      option: json['option'] != null
          ? Map<String, dynamic>.from(json['option'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'type': type,
      'option': option,
    };
  }
}

abstract class TranslationEngine {
  TranslationEngineConfig config;

  String get type => config.type;
  String get identifier => config.identifier;
  String get name => config.name;
  Map<String, dynamic> get option => config.option;

  TranslationEngine(this.config);

  Future<LookUpResponse> lookUp(LookUpRequest request);

  Future<TranslateResponse> translate(TranslateRequest request);

  Map<String, dynamic> toJson() {
    return {
      'identifier': config.identifier,
      'type': type,
      'name': config.name,
    };
  }
}
