import './translation.dart';

class TranslateResponse {
  List<Translation> translations;

  TranslateResponse({
    this.translations,
  });

  factory TranslateResponse.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    List<Translation> translations;

    return TranslateResponse(
      translations: translations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'translations': translations?.map((e) => e.toJson())?.toList(),
    }..removeWhere((key, value) => value == null);
  }
}
