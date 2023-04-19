import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memento_flutter/api/note_api.dart';
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

  static Future<List<dynamic>> getKeywordList(int noteId) async {
    final response = await http.get(
      Uri.parse('${Constants.baseURL}/keyword/$noteId'),
      headers: {
        "Authorization": "Bearer ${Constants.accessToken}",
      },
    );

    if (response.statusCode == 200) {
      final selectedIndex = jsonDecode(utf8.decode(response.bodyBytes));
      final note = await NoteAPI.fetchNote(noteId: noteId);
      return sliceText(
          totalText: note["content"], selectedIndex: selectedIndex);
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('키워드를 가져오지 못했습니다.');
    }
  }

  /* 선택한 문자와 그러지 않은 문자를 나눠서 selectedText에 저장 */
  static List sliceText(
      {required String totalText, required List selectedIndex}) {
    List result = []; // 선택한 문자 {text, isKeyword}
    int prevEndIndex = 0; // 이전 end index

    for (final index in selectedIndex) {
      final start = index["first"];
      final end = index["last"];

      result.add({
        "text": totalText.substring(prevEndIndex, start),
        "isKeyword": false
      });
      result.add({"text": totalText.substring(start, end), "isKeyword": true});
      prevEndIndex = end; // 이전 end index 저장
    }
    // 마지막 문자 저장
    result.add({"text": totalText.substring(prevEndIndex), "isKeyword": false});

    return result;
  }
}
