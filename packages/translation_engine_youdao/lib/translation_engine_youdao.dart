library translation_engine_youdao;

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:translate_client/translate_client.dart';

const String kEngineTypeYoudao = 'youdao';

const String _kEngineOptionKeyAppKey = 'appKey';
const String _kEngineOptionKeyAppSecret = 'appSecret';

String _md5(String data) {
  return md5.convert(utf8.encode(data)).toString();
}

String _sha256(String data) {
  return sha256.convert(utf8.encode(data)).toString();
}

class YoudaoTranslationEngine extends TranslationEngine {
  static List<String> optionKeys = [
    _kEngineOptionKeyAppKey,
    _kEngineOptionKeyAppSecret,
  ];

  YoudaoTranslationEngine({
    String identifier,
    String name,
    Map<String, dynamic> option,
  }) : super(identifier: identifier, name: name, option: option);

  String get type => kEngineTypeYoudao;

  String get _optionAppKey => option[_kEngineOptionKeyAppKey];
  String get _optionAppSecret => option[_kEngineOptionKeyAppSecret];

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) async {
    LookUpResponse lookUpResponse = LookUpResponse(engine: name);

    String q = request.word;
    String input = q;
    if (q.length > 20)
      input = '${q.substring(0, 10)}${q.length}${q.substring(q.length - 10)}';

    final curtime = (DateTime.now().millisecondsSinceEpoch ~/ 1000);
    final salt = _md5("translation_engine_youdao");
    final sign =
        _sha256('$_optionAppKey$input$salt${curtime}$_optionAppSecret');

    print(curtime);

    Uri uri = Uri.https(
      'openapi.youdao.com',
      '/api',
      {
        'q': request.word,
        'from': 'auto',
        'to': 'auto',
        'appKey': _optionAppKey,
        'salt': salt.toString(),
        'sign': sign.toString(),
        'signType': 'v3',
        'curtime': '$curtime',
      },
    );

    print(uri.toString());

    var response = await http.get(uri.toString());
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    print(response.body);

    var query = data['query'];
    var translation = data['translation'];
    var basic = data['basic'];
    var returnPhrase = data['returnPhrase'];
    var tSpeakUrl = data['tSpeakUrl'];
    var speakUrl = data['speakUrl'];

    if (returnPhrase != null) {
      lookUpResponse.word = returnPhrase[0];
    }

    if (basic != null) {
      var explains = basic['explains'];
      var wfs = basic['wfs'];
      if (explains != null) {
        lookUpResponse.definitions = (explains as List).map((e) {
          String def = e.toString();
          int dotIndex = def.indexOf('. ');
          String name = dotIndex >= 0 ? def.substring(0, dotIndex + 1) : null;
          String value = dotIndex >= 0 ? def.substring(dotIndex + 2) : def;
          List<String> values = value.split('；');

          return WordDefinition(
            name: name,
            values: values,
          );
        }).toList();
      }

      lookUpResponse.pronunciations = [
        WordPronunciation(
            type: 'uk',
            phoneticSymbol: basic['uk-phonetic'],
            audioUrl: basic['uk-speech']),
        WordPronunciation(
            type: 'us',
            phoneticSymbol: basic['us-phonetic'],
            audioUrl: basic['us-speech']),
      ]
          .where((e) =>
              (e.phoneticSymbol ?? '').isNotEmpty ||
              (e.audioUrl ?? '').isNotEmpty)
          .toList();

      if (wfs != null) {
        lookUpResponse.tenses = (wfs as List).map((e) {
          var wf = e['wf'];
          String name = wf['name'];
          String value = wf['value'];

          List<String> values = [value];
          if (value.indexOf('或') >= 0) {
            values = value.split('或');
          }

          return WordTense(
            name: name,
            values: values,
          );
        }).toList();
      }
    }

    return lookUpResponse;
  }

  @override
  Future<TranslateResponse> translate(TranslateRequest request) {
    throw UnimplementedError();
  }
}
