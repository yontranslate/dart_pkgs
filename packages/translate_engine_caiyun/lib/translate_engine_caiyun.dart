library translate_engine_caiyun;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:translate_client/translate_client.dart';

class CaiyunTranslateEngine extends TranslateEngine {
  String get id => '$name-xxx';
  String get name => 'caiyun';

  String token;
  String requestId;

  CaiyunTranslateEngine({
    this.token,
    this.requestId,
  });

  factory CaiyunTranslateEngine.newInstance(Map<String, dynamic> json) {
    if (json == null) return null;

    return CaiyunTranslateEngine(
      token: json['token'],
      requestId: json['requestId'],
    );
  }

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<TranslateResponse> translate(TranslateRequest request) async {
    TranslateResponse translateResponse = TranslateResponse(engine: name);

    String transType = 'auto';
    if (request.sourceLanguage != null && request.targetLanguage != null) {
      transType =
          '${request.sourceLanguage.code}2${request.targetLanguage.code}';
    }

    final payload = {
      'source': [request.text],
      'trans_type': transType,
      'request_id': requestId,
    };
    final response = await http.post(
      'http://api.interpreter.caiyunai.com/v1/translator',
      headers: {
        'Content-Type': 'application/json',
        'X-Authorization': 'token ${token}',
      },
      body: json.encode(payload),
    );
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    print(response.body);

    translateResponse.translations = (data['target'] as List).map(
      (e) {
        return Translation(text: e);
      },
    ).toList();

    return translateResponse;
  }
}
