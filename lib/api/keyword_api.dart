import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memento_flutter/api/note_api.dart';
import 'package:memento_flutter/api/user_api.dart';
import 'package:memento_flutter/config/constants.dart';

import 'package:memento_flutter/utility/storage.dart';

class KeywordAPI {
  static Future saveKeyword(List keywordList) async {
    final accessToken = await Storage.getAccessToken();
    final response = await http.post(
        Uri.parse('${Constants.baseURL}/keyword/save'),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
        body: jsonEncode(keywordList));

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('키워드를 저장하지 못했습니다.');
    }
  }

  static Future editKeyword({required List indexList}) async {
    final accessToken = await Storage.getAccessToken();
    final response = await http.post(
        Uri.parse('${Constants.baseURL}/keyword/edit'),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
        body: jsonEncode(indexList));

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      await UserAPI.refreshToken();
      await editKeyword(indexList: indexList);
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('키워드를 수정하지 못했습니다.');
    }
  }

  static Future getIndexList(int noteId) async {
    final accessToken = await Storage.getAccessToken();
    final response = await http.get(
      Uri.parse('${Constants.baseURL}/keyword/$noteId'),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('키워드를 가져오지 못했습니다.');
    }
  }

  static Future<List<dynamic>> getKeywordList(int noteId) async {
    final indexList = await getIndexList(noteId);
    final note = await NoteAPI.fetchNote(noteId: noteId);

    return sliceText(content: note["content"], selectedIndex: indexList);
  }

  /* 선택한 문자와 그러지 않은 문자를 나눠서 selectedText에 저장 */
  static List sliceText(
      {required String content, required List selectedIndex}) {
    List result = []; // 선택한 문자 {text, isKeyword}
    int prevEndIndex = 0; // 이전 end index

    for (final index in selectedIndex) {
      final start = index["first"];
      final end = index["last"];

      result.add(
          {"text": content.substring(prevEndIndex, start), "isKeyword": false});
      result.add({"text": content.substring(start, end), "isKeyword": true});
      prevEndIndex = end; // 이전 end index 저장
    }
    // 마지막 문자 저장
    result.add({"text": content.substring(prevEndIndex), "isKeyword": false});

    return result;
  }

  static Future deleteKeyword({required int noteId}) async {
    final accessToken = await Storage.getAccessToken();
    final response = await http.delete(
      Uri.parse('${Constants.baseURL}/keyword/deleteBynoteid/$noteId'),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('키워드를 삭제하지 못했습니다.');
    }
  }
}
