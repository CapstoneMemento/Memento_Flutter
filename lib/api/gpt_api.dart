import 'dart:convert';

import 'package:memento_flutter/api/user_api.dart';
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
      print(jsonDecode(utf8.decode(response.bodyBytes)));
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 401) {
      await UserAPI.refreshToken();
      await recommentKeyword(content: content);
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('키워드를 수정하지 못했습니다.');
    }
  }
}
