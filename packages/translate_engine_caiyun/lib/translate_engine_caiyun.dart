library translate_engine_caiyun;

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:translate_client/translate_client.dart';

String _md5(String data) {
  return md5.convert(utf8.encode(data)).toString();
}

String _sha256(String data) {
  return sha256.convert(utf8.encode(data)).toString();
}

class CaiyunTranslateEngine extends TranslateEngine {
  String get id => '$name-xxx';
  String get name => 'caiyun';

  String token;
  String requestId;

  CaiyunTranslateEngine({
    this.token,
    this.requestId,
  });

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<TranslateResponse> translate(TranslateRequest request) async {
    TranslateResponse translateResponse = TranslateResponse(engine: name);

    var payload = {
      "source": [request.text],
      "trans_type": "en2zh",
      "request_id": requestId,
    };
    var response = await http.post(
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
