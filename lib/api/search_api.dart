import 'dart:convert';

import 'package:memento_flutter/config/constants.dart';
import 'package:http/http.dart' as http;

class SearchAPI {
  static Future<List<dynamic>> fetchSearchList(query) async {
    final response = await http.get(
        Uri.parse('${Constants.baseURL}/search/find?query=$query'),
        headers: {"Authorization": "Bearer ${Constants.accessToken}"});

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('검색 결과를 가져오는데 실패했습니다.');
    }
  }
}
