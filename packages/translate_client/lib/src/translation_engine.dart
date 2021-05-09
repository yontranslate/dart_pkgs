import 'models/look_up_request.dart';
import 'models/look_up_response.dart';
import 'models/translate_request.dart';
import 'models/translate_response.dart';

class TranslationEngineConfig {
  final String type;
  final String identifier;
  final String name;
  final Map<String, dynamic> option;

  TranslationEngineConfig({
    this.type,
    this.identifier,
    this.name,
    this.option,
  });

  factory TranslationEngineConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return TranslationEngineConfig(
      type: json['type'],
      identifier: json['identifier'],
      name: json['name'],
      option: json['option'] != null
          ? Map<String, dynamic>.from(json['option'])
          : null,
    );
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
