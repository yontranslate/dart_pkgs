library translation_engine_iciba;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:translate_client/translate_client.dart';

const String kEngineTypeIciba = 'iciba';

const String _kEngineOptionKeyApiKey = 'apiKey';

class IcibaTranslationEngine extends TranslationEngine {
  static List<String> optionKeys = [
    _kEngineOptionKeyApiKey,
  ];

  IcibaTranslationEngine(TranslationEngineConfig config) : super(config);

  String get type => kEngineTypeIciba;

  String get _optionApiKey => option[_kEngineOptionKeyApiKey];

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) async {
    LookUpResponse lookUpResponse = LookUpResponse(engine: name);

    Uri uri = Uri.http(
      'dict-co.iciba.com',
      '/api/dictionary.php',
      {
        'w': request.word,
        'key': _optionApiKey,
        'type': 'json',
      },
    );

    print(uri.toString());

    var response = await http.get(uri.toString());
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    print(response.body);

    lookUpResponse.word = data['word_name'];

    var symbol = data['symbols'][0];
    var parts = symbol['parts'];

    if (parts != null) {
      lookUpResponse.definitions = (parts as List).map((e) {
        String name = e['part'];
        List<String> values =
            (e['means'] as List).map((e) => e.toString()).toList();

        return WordDefinition(
          name: name,
          values: values,
        );
      }).toList();

      lookUpResponse.pronunciations = [
        WordPronunciation(
          type: 'uk',
          phoneticSymbol: symbol['ph_en'],
          audioUrl: symbol['ph_en_mp3'],
        ),
        WordPronunciation(
          type: 'us',
          phoneticSymbol: symbol['ph_am'],
          audioUrl: symbol['ph_am_mp3'],
        ),
      ]
          .where((e) =>
              (e.phoneticSymbol ?? '').isNotEmpty ||
              (e.audioUrl ?? '').isNotEmpty)
          .toList();
    }

    if (data['exchange'] != null) {
      Map<String, String> map = {
        'word_pl': '复数',
        'word_third': '第三人称单数',
        'word_past': '过去式',
        'word_done': '过去分词',
        'word_ing': '现在分词',
        'word_er': 'word_er',
        'word_est': 'word_est',
      };
      lookUpResponse.tenses = (data['exchange'] as Map)
          .keys
          .map((k) {
            String name = map[k];
            dynamic value = (data['exchange'][k]);
            List<String> values = [];

            if (value is List) {
              values = (value).map((e) => e.toString()).toList();
            }

            return WordTense(
              name: name,
              values: values,
            );
          })
          .where((e) => e.values.length > 0)
          .toList();

      if (lookUpResponse.tenses.length == 0) {
        lookUpResponse.tenses = null;
      }
    }

    return lookUpResponse;
  }

  @override
  Future<TranslateResponse> translate(TranslateRequest request) async {
    throw UnimplementedError();
  }
}
