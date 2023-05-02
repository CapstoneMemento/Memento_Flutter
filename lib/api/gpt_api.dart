import 'dart:convert';

import 'package:memento_flutter/config/constants.dart';

import 'package:memento_flutter/utility/storage.dart';
import 'package:http/http.dart' as http;

class GptAPI {
  static Future recommentKeyword({required String content}) async {
    final accessToken = await Storage.getAccessToken();
    final data = {
      "categories_id": 0,
      "content": content,
      "title": "",
      "type": "keyword"
    };
    final response = await http.post(
        Uri.parse('${Constants.baseURL}/chat-gpt/question'),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('키워드를 추천받지 못했습니다.');
    }
  }
}
