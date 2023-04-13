import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memento_flutter/config/constants.dart';

class KeywordAPI {
  static Future<List<dynamic>> saveKeyword(List keywordList) async {
    final response =
        await http.post(Uri.parse('${Constants.baseURL}/keyword/save'),
            headers: {
              "Authorization": "Bearer ${Constants.accessToken}",
              "Content-Type": "application/json"
            },
            body: json.encode(keywordList));

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('키워드를 저장하지 못했습니다.');
    }
  }
}
