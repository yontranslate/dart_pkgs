class Language {
  static final Language DE = Language('de', 'German');
  static final Language EN = Language('en', 'English');
  static final Language ES = Language('es', 'Spanish');
  static final Language FR = Language('fr', 'French');
  static final Language IT = Language('it', 'Italian');
  static final Language JA = Language('ja', 'Japanese');
  static final Language NL = Language('nl', 'Dutch');
  static final Language PL = Language('pl', 'Polish');
  static final Language PT = Language('pt', 'Portuguese');
  static final Language RU = Language('ru', 'Russian');
  static final Language ZH = Language('zh', 'Chinese');

  String code;
  String name;

  Language(this.code, this.name);
}
