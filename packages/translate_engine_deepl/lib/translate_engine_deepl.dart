library translate_engine_deepl;

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:translate_client/translate_client.dart';

class DeepLTranslateEngine extends TranslateEngine {
  String get id => '$name-xxx';
  String get name => 'deepl';

  DeepLTranslateEngine({this.authKey});

  final String authKey;

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<TranslateResponse> translate(TranslateRequest request) async {
    TranslateResponse translateResponse = TranslateResponse(engine: name);

    Map<String, String> queryParameters = {
      'auth_key': this.authKey,
      'text': request.text,
      'target_lang': 'ZH',
    };
    var uri = Uri.https('api.deepl.com', '/v2/translate', queryParameters);
    print(uri.toString());

    var response = await http.post(uri.toString(), headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8"
    });

    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));

    if (data['translations'] != null) {
      Iterable l = data['translations'] as List;
      translateResponse.translations = l
          .map((e) => Translation(
                detectedSourceLanguage: e['detected_source_language'],
                text: e['text'],
              ))
          .toList();
    }

    print(data);
    if (data['error'] != null) {
      throw NotFoundException(message: data['errorMessage']);
    }

    return translateResponse;
  }
}
