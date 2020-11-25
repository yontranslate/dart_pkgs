import 'translate_response.dart';
import 'translation.dart';
import 'word_definition.dart';
import 'word_image.dart';
import 'word_phonetic.dart';
import 'word_phrase.dart';
import 'word_pronunciation.dart';
import 'word_sentence.dart';
import 'word_tense.dart';

class LookUpResponse extends TranslateResponse {
  String word; // 单词
  String tip; // 提示
  List<WordDefinition> definitions; // 定义（基本释义）
  List<WordPhonetic> phonetics; // 发音
  List<WordPronunciation> pronunciations; // 发音
  List<WordImage> images; // 图片
  List<WordPhrase> phrases; // 短语
  List<WordTense> tenses; // 时态
  List<WordSentence> sentences; // 例句

  LookUpResponse({
    String engine,
    List<Translation> translations,
    this.word,
    this.tip,
    this.definitions,
    this.phonetics,
    this.pronunciations,
    this.images,
    this.phrases,
    this.tenses,
    this.sentences,
  }) : super(
          engine: engine,
          translations: translations,
        );

  factory LookUpResponse.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return LookUpResponse(
      word: json['word'],
      tip: json['tip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'engine': super.engine,
      'word': word,
      'tip': tip,
      'definitions': definitions?.map((e) => e.toJson())?.toList(),
      'phonetics': phonetics?.map((e) => e.toJson())?.toList(),
      'pronunciations': pronunciations?.map((e) => e.toJson())?.toList(),
      'images': images?.map((e) => e.toJson())?.toList(),
      'phrases': phrases?.map((e) => e.toJson())?.toList(),
      'tenses': tenses?.map((e) => e.toJson())?.toList(),
      'sentences': sentences?.map((e) => e.toJson())?.toList(),
    };
  }
}
