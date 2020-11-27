library translate_engine_tencent;

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:translate_client/translate_client.dart';

String _signature(String key, String data) {
  var hmacSha1 = new Hmac(sha1, utf8.encode(key));
  var digest = hmacSha1.convert(utf8.encode(data));

  return base64.encode(digest.bytes).toString();
}

class TencentTranslateEngine extends TranslateEngine {
  String get id => '$name-xxx';
  String get name => 'tencent';

  String secretId;
  String secretKey;

  TencentTranslateEngine({
    this.secretId,
    this.secretKey,
  });

  factory TencentTranslateEngine.newInstance(Map<String, dynamic> json) {
    if (json == null) return null;

    return TencentTranslateEngine(
      secretId: json['secretId'],
      secretKey: json['secretKey'],
    );
  }

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) async {
    throw UnimplementedError();
  }

  @override
  Future<TranslateResponse> translate(TranslateRequest request) async {
    TranslateResponse translateResponse = TranslateResponse(engine: name);

    Map<String, String> queryParameters = {
      'Action': 'TextTranslate',
      'Language': 'zh-CN',
      'Nonce': '${Random().nextInt(9999)}',
      'ProjectId': '0',
      'Region': 'ap-guangzhou',
      'SecretId': secretId,
      'Source': 'auto',
      'SourceText': request.text,
      'Target': 'zh',
      'Timestamp': '${DateTime.now().millisecondsSinceEpoch ~/ 1000}',
      'Version': '2018-03-21',
    };

    List<String> keys = queryParameters.keys.toList();
    keys.sort((a, b) => a.compareTo(b));
    String query = keys.map((key) => '$key=${queryParameters[key]}').join('&');
    print(query);

    String endpoint = 'tmt.tencentcloudapi.com';
    String srcStr = 'POST$endpoint/?${query}';
    print(srcStr);
    String signature = _signature(this.secretKey, srcStr);
    print(signature);

    queryParameters.putIfAbsent('Signature', () => signature);

    keys = queryParameters.keys.toList();
    keys.sort((a, b) => a.compareTo(b));
    query = keys.map((key) => '$key=${queryParameters[key]}').join('&');

    print('$endpoint/?$query');

    var response = await http.post('https://$endpoint',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: queryParameters);
    print(response);
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    print(json.encode(data));

    translateResponse.translations = [
      Translation(text: data['Response']['TargetText']),
    ];

    return translateResponse;
  }
}
