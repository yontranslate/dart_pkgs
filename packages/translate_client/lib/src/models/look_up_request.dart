import 'language.dart';
import 'translate_request.dart';

class LookUpRequest extends TranslateRequest {
  final String word;

  LookUpRequest({
    this.word,
    Language sourceLanguage,
    Language targetLanguage,
  }) : super(
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
        );

  factory LookUpRequest.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return LookUpRequest(
      word: json['word'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
    };
  }
}
