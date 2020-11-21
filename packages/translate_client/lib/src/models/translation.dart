class Translation {
  String detectedSourceLanguage;
  String text;

  Translation({
    this.detectedSourceLanguage,
    this.text,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return Translation(
      detectedSourceLanguage: json['detectedSourceLanguage'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detectedSourceLanguage': detectedSourceLanguage,
      'text': text,
    };
  }
}
