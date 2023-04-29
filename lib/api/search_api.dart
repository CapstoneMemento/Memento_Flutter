import 'dart:convert';

import 'package:memento_flutter/config/constants.dart';
import 'package:http/http.dart' as http;

import 'package:memento_flutter/utility/storage.dart';

class SearchAPI {
  static Future fetchSearchList(query) async {
    final accessToken = await Storage.getAccessToken();
    final response = await http.get(
        Uri.parse('${Constants.baseURL}/search/find?query=$query'),
        headers: {"Authorization": "Bearer $accessToken"});

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('검색 결과를 가져오는데 실패했습니다.');
    }
  }

  static Future fetchContent({required int caseId}) async {
    final accessToken = await Storage.getAccessToken();

    final response = await http.get(
      Uri.parse("${Constants.baseURL}/search/content?caseid=$caseId"),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('판례를 가져오는데 실패했습니다.');
    }
  }
}
