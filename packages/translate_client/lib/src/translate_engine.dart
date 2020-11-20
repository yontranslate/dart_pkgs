import 'models/look_up_request.dart';
import 'models/look_up_response.dart';
import 'models/translate_request.dart';
import 'models/translate_response.dart';

abstract class TranslateEngine {
  String get id;
  String get name;

  Future<LookUpResponse> lookUp(LookUpRequest request);
  Future<TranslateResponse> translate(TranslateRequest request);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
