class TranslateRequest {
  final String text;

  TranslateRequest({this.text});

  factory TranslateRequest.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return TranslateRequest(
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}
