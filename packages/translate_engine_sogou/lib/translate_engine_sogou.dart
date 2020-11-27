library translate_engine_sogou;

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:translate_client/translate_client.dart';

String _md5(String data) {
  return md5.convert(utf8.encode(data)).toString();
}

class SogouTranslateEngine extends TranslateEngine {
  String get id => '$name-xxx';
  String get name => 'sogou';

  String pid;
  String key;

  SogouTranslateEngine({
    this.pid,
    this.key,
  });

  factory SogouTranslateEngine.newInstance(Map<String, dynamic> json) {
    if (json == null) return null;

    return SogouTranslateEngine(
      pid: json['pid'],
      key: json['key'],
    );
  }

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) async {
    LookUpResponse lookUpResponse = LookUpResponse(engine: name);

    String q = request.word;

    final curtime = (DateTime.now().millisecondsSinceEpoch ~/ 1000);
    final salt = Random().nextInt(999999);
    final sign = _md5('$pid$q$salt$key');

    print(curtime);

    Uri uri = Uri.http(
      'fanyi.sogou.com',
      '/reventondc/api/sogouTranslate',
      {
        'q': request.word,
        'from': 'auto',
        'to': 'zh-CHS',
        'pid': this.pid,
        'salt': salt.toString(),
        'sign': sign.toString(),
        'dict': 'true',
      },
    );

    print(uri.toString());

    var response = await http.post(uri.toString(), headers: {
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
