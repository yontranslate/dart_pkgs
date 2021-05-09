library translation_engine_cloudoptai;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:translate_client/translate_client.dart';

const String kEngineTypeCloudoptAI = 'cloudoptai';

class CloudoptAITranslationEngine extends TranslationEngine {
  String get type => kEngineTypeCloudoptAI;

  CloudoptAITranslationEngine(TranslationEngineConfig config) : super(config);

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) async {
    LookUpResponse lookUpResponse = LookUpResponse(engine: name);

    var response = await http.get(
        'https://ai.cloudopt.net/api/v1/dict/${Uri.encodeQueryComponent(request.word)}');
    Map<String, dynamic> data = json.decode(response.body);
    if (data['error'] != null) {
      throw NotFoundException(message: data['errorMessage']);
    }

    Map<String, dynamic> result = data['result'];

    lookUpResponse.word = result['word'];

    if (result['translation'] != null) {
      lookUpResponse.definitions = (result['translation'] as List).map((e) {
        String def = e.toString();
        int dotIndex = def.indexOf('. ');
        String name = dotIndex >= 0 ? def.substring(0, dotIndex + 1) : null;
        String value = dotIndex >= 0 ? def.substring(dotIndex + 2) : def;
        List<String> values = value.split(', ');

        return WordDefinition(
          name: name,
          values: values,
        );
      }).toList();

      if (result['phonetic'] != null) {
        lookUpResponse.pronunciations = (result['phonetic'] as List)
            .asMap()
            .map((index, value) {
              var types = {
                0: 'uk',
                1: 'us',
              };
              return MapEntry(
                index,
                WordPronunciation(
                  type: types[index],
                  phoneticSymbol: value,
                  audioUrl: result['audio'][index],
                ),
              );
            })
            .values
            .where((e) =>
                (e.phoneticSymbol ?? '').isNotEmpty ||
                (e.audioUrl ?? '').isNotEmpty)
            .toList();
      }

      if (result['exchange'] != null) {
        const map = {
          'p': '过去式',
          'd': '过去分词',
          'i': '现在分词',
          '3': '第三人称单数',
          'r': '比较级',
          't': '最高级',
          's': '复数',
          '0': '原型',
        };

        lookUpResponse.tenses = (result['exchange'] as List)
            .where((e) => e['state'] != '1')
            .map((e) {
          String state = e['state'];
          String value = e['word'];

          String name = map[state];
          List<String> values = [value];

          return WordTense(
            name: name,
            values: values,
          );
        }).toList();

        if (lookUpResponse.tenses.length == 0) {
          lookUpResponse.tenses = null;
        }
      }
    }

    return lookUpResponse;
  }

  @override
  Future<TranslateResponse> translate(TranslateRequest request) {
    throw UnimplementedError();
  }
}
