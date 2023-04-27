import 'dart:convert';

import 'package:memento_flutter/api/user_api.dart';
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
    } else if (response.statusCode == 401) {
      await UserAPI.refreshToken();
      await fetchSearchList(query);
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('검색 결과를 가져오는데 실패했습니다.');
    }
  }

  static Future fetchContent({required Map<String, dynamic> caseInfo}) async {
    final accessToken = await Storage.getAccessToken();
    // value를 String으로 변환
    for (final key in caseInfo.keys) {
      caseInfo[key] = '${caseInfo[key]}';
    }

    var uri = Uri.parse("${Constants.baseURL}/search/content");
    uri = uri.replace(queryParameters: caseInfo);

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 401) {
      await UserAPI.refreshToken();
      await fetchContent(caseInfo: caseInfo);
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('판례를 가져오는데 실패했습니다.');
    }
  }
}
