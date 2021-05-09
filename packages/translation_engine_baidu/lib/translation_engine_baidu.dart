library translation_engine_baidu;

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:translate_client/translate_client.dart';

const String kEngineTypeBaidu = 'baidu';

const String _kEngineOptionKeyAppId = 'appId';
const String _kEngineOptionKeyAppKey = 'appKey';

String _md5(String data) {
  return md5.convert(utf8.encode(data)).toString();
}

class BaiduTranslationEngine extends TranslationEngine {
  static List<String> optionKeys = [
    _kEngineOptionKeyAppId,
    _kEngineOptionKeyAppKey,
  ];

  BaiduTranslationEngine(TranslationEngineConfig config) : super(config);

  String get type => kEngineTypeBaidu;

  String get _optionAppId => option[_kEngineOptionKeyAppId];
  String get _optionAppKey => option[_kEngineOptionKeyAppKey];

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) async {
    throw UnimplementedError();
  }

  @override
  Future<TranslateResponse> translate(TranslateRequest request) async {
    TranslateResponse translateResponse = TranslateResponse();

    final salt = Random().nextInt(999999);
    final sign = _md5('$_optionAppId${request.text}$salt$_optionAppKey');

    Uri uri = Uri.https(
      'fanyi-api.baidu.com',
      '/api/trans/vip/translate',
      {
        'q': request.text,
        'from': 'auto',
        'to': 'zh',
        'appid': _optionAppId,
        'salt': salt.toString(),
        'sign': sign.toString(),
        'dict': '0',
      },
    );

    print(uri.toString());

    var response = await http.post(uri, headers: {
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
