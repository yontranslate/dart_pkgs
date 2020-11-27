library translate_engine_baidu;

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:translate_client/translate_client.dart';

String _md5(String data) {
  return md5.convert(utf8.encode(data)).toString();
}

class BaiduTranslateEngine extends TranslateEngine {
  String get id => '$name-xxx';
  String get name => 'baidu';

  String appId;
  String appKey;

  BaiduTranslateEngine({
    this.appId,
    this.appKey,
  });

  factory BaiduTranslateEngine.newInstance(Map<String, dynamic> json) {
    if (json == null) return null;

    return BaiduTranslateEngine(
      appId: json['appId'],
      appKey: json['appKey'],
    );
  }

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) async {
    throw UnimplementedError();
  }

  @override
  Future<TranslateResponse> translate(TranslateRequest request) async {
    TranslateResponse translateResponse = TranslateResponse(engine: name);

    final salt = Random().nextInt(999999);
    final sign = _md5('$appId${request.text}$salt$appKey');

    Uri uri = Uri.https(
      'fanyi-api.baidu.com',
      '/api/trans/vip/translate',
      {
        'q': request.text,
        'from': 'auto',
        'to': 'zh',
        'appid': this.appId,
        'salt': salt.toString(),
        'sign': sign.toString(),
        'dict': '0',
      },
    );

    print(uri.toString());

    var response = await http.post(uri.toString(), headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    });
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    print(response.body);

    translateResponse.translations = (data['trans_result'] as List).map((e) {
      return Translation(
        text: e['dst'],
      );
    }).toList();

    return translateResponse;
  }
}
