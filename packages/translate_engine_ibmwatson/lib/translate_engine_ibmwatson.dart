library translate_engine_ibmwatson;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:translate_client/translate_client.dart';

const String kEngineTypeIBMWatson = 'ibmwatson';

const String _kEngineOptionKeyApiKey = 'apiKey';
const String _kEngineOptionKeyApiUrl = 'apiUrl';

String _base64(String data) {
  return base64.encode(utf8.encode(data)).toString();
}

class IBMWatsonTranslateEngine extends TranslateEngine {
  static List<String> optionKeys = [
    _kEngineOptionKeyApiKey,
    _kEngineOptionKeyApiUrl,
  ];

  IBMWatsonTranslateEngine({
    String identifier,
    String name,
    Map<String, dynamic> option,
  }) : super(identifier: identifier, name: name, option: option);

  String get type => kEngineTypeIBMWatson;

  String get _optionApiKey => option[_kEngineOptionKeyApiKey];
  String get _optionApiUrl => option[_kEngineOptionKeyApiUrl];

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) async {
    throw UnimplementedError();
  }

  @override
  Future<TranslateResponse> translate(TranslateRequest request) async {
    TranslateResponse translateResponse = TranslateResponse(engine: name);

    var response = await http.post(
      '$_optionApiUrl/v3/translate?version=2018-05-01',
      headers: {
        'Authorization': 'Basic ${_base64('apikey:$_optionApiKey')}',
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
