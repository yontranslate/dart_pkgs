import './translation.dart';

class TranslateResponse {
  String engine;
  List<Translation> translations;

  TranslateResponse({
    this.engine,
    this.translations,
  });

  factory TranslateResponse.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    List<Translation> translations;

    return TranslateResponse(
      engine: json['engine'],
      translations: translations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'engine': engine,
      'translations': translations?.map((e) => e.toJson())?.toList(),
    };
  }
}
