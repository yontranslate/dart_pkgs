library translate_engine_ibmwatson;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:translate_client/translate_client.dart';

String _base64(String data) {
  return base64.encode(utf8.encode(data)).toString();
}

class IBMWatsonTranslateEngine extends TranslateEngine {
  String get id => '$name-xxx';
  String get name => 'ibmwatson';

  String apiKey;
  String apiUrl;

  IBMWatsonTranslateEngine({
    this.apiKey,
    this.apiUrl,
  });

  factory IBMWatsonTranslateEngine.newInstance(Map<String, dynamic> json) {
    if (json == null) return null;

    return IBMWatsonTranslateEngine(
      apiKey: json['apiKey'],
      apiUrl: json['apiUrl'],
    );
  }

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) async {
    throw UnimplementedError();
  }

  @override
  Future<TranslateResponse> translate(TranslateRequest request) async {
    TranslateResponse translateResponse = TranslateResponse(engine: name);

    var response = await http.post(
      '$apiUrl/v3/translate?version=2018-05-01',
      headers: {
        'Authorization': 'Basic ${_base64('apikey:$apiKey')}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'model_id': 'en-zh',
        'text': [request.text],
      }),
    );
    print(response);
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    print(json.encode(data));

    translateResponse.translations = (data['translations'] as List).map((e) {
      return Translation(text: e['translation']);
    }).toList();

    return translateResponse;
  }
}
