library translation_engine_sogou;

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:translate_client/translate_client.dart';

const String kEngineTypeSogou = 'sogou';

const String _kEngineOptionKeyPid = 'pid';
const String _kEngineOptionKeyKey = 'key';

String _md5(String data) {
  return md5.convert(utf8.encode(data)).toString();
}

class SogouTranslationEngine extends TranslationEngine {
  static List<String> optionKeys = [
    _kEngineOptionKeyPid,
    _kEngineOptionKeyKey,
  ];

  SogouTranslationEngine({
    String identifier,
    String name,
    Map<String, dynamic> option,
  }) : super(identifier: identifier, name: name, option: option);

  String get type => kEngineTypeSogou;

  String get _optionPid => option[_kEngineOptionKeyPid];
  String get _optionKey => option[_kEngineOptionKeyKey];

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) async {
    LookUpResponse lookUpResponse = LookUpResponse(engine: name);

    String q = request.word;

    final curtime = (DateTime.now().millisecondsSinceEpoch ~/ 1000);
    final salt = Random().nextInt(999999);
    final sign = _md5('$_optionPid$q$salt$_optionKey');

    print(curtime);

    Uri uri = Uri.http(
      'fanyi.sogou.com',
      '/reventondc/api/sogouTranslate',
      {
        'q': request.word,
        'from': 'auto',
        'to': 'zh-CHS',
        'pid': _optionPid,
        'salt': salt.toString(),
        'sign': sign.toString(),
        'dict': 'true',
      },
    );

    print(uri.toString());

    var response = await http.post(uri, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    });
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    print(response.body);

    lookUpResponse.word = data['query'];

    if (data['usual'] != null) {
      var usual = data['usual'];

      lookUpResponse.definitions = (usual as List).map((e) {
        String name = e['pos'];
        List<String> values =
            (e['values'] as List).map((e) => e.toString()).toList();

        return WordDefinition(
          name: name,
          values: values,
        );
      }).toList();
    }

    if (data['phonetic'] != null) {
      lookUpResponse.phonetics = (data['phonetic'] as List).map((e) {
        return WordPhonetic(
          type: e['type'],
          alphabet: e['text'],
          audioUrl: e['filename'],
        );
      }).toList();
    }

    return lookUpResponse;
  }

  @override
  Future<TranslateResponse> translate(TranslateRequest request) {
    throw UnimplementedError();
  }
}
