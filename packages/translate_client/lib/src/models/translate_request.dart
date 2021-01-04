import 'language.dart';

class TranslateRequest {
  final Language sourceLanguage;
  final Language targetLanguage;
  final String text;

  TranslateRequest({
    this.sourceLanguage,
    this.targetLanguage,
    this.text,
  });

  factory TranslateRequest.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return TranslateRequest(
      sourceLanguage: Language.fromJson(json['sourceLanguage']),
      targetLanguage: Language.fromJson(json['targetLanguage']),
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sourceLanguage': sourceLanguage?.toJson(),
      'targetLanguage': targetLanguage?.toJson(),
      'text': text,
    };
  }
}
