library translation_engine_caiyun;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:translate_client/translate_client.dart';

const String kEngineTypeCaiyun = 'caiyun';

const String _kEngineOptionKeyToken = 'token';
const String _kEngineOptionKeyRequestId = 'requestId';

class CaiyunTranslationEngine extends TranslationEngine {
  static List<String> optionKeys = [
    _kEngineOptionKeyToken,
    _kEngineOptionKeyRequestId,
  ];

  CaiyunTranslationEngine({
    String identifier,
    String name,
    Map<String, dynamic> option,
  }) : super(identifier: identifier, name: name, option: option);

  String get type => kEngineTypeCaiyun;

  String get _optionToken => option[_kEngineOptionKeyToken];
  String get _optionRequestId => option[_kEngineOptionKeyRequestId];

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<TranslateResponse> translate(TranslateRequest request) async {
    TranslateResponse translateResponse = TranslateResponse();

    String transType = 'auto';
    if (request.sourceLanguage != null && request.targetLanguage != null) {
      transType =
          '${request.sourceLanguage.code}2${request.targetLanguage.code}';
    }

    final payload = {
      'source': [request.text],
      'trans_type': transType,
      'request_id': _optionRequestId,
    };
    final response = await http.post(
      Uri.parse('http://api.interpreter.caiyunai.com/v1/translator'),
      headers: {
        'Content-Type': 'application/json',
        'X-Authorization': 'token ${_optionToken}',
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
