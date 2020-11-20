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

    return TranslateResponse(
      engine: json['engine'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'engine': engine,
    };
  }
}
