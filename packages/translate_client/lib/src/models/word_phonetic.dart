class WordPhonetic {
  String type;
  String alphabet;
  String audioUrl;

  WordPhonetic({this.type, this.alphabet, this.audioUrl});

  factory WordPhonetic.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return WordPhonetic(
      type: json['type'],
      alphabet: json['alphabet'],
      audioUrl: json['audioUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'alphabet': alphabet,
      'audioUrl': audioUrl,
    };
  }
}
