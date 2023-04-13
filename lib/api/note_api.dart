import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memento_flutter/config/constants.dart';

class NoteAPi {
  static final basicHeaders = {
    "Authorization": "Bearer ${Constants.accessToken}",
    "Content-Type": "application/json"
  };

  static Future<List<dynamic>> fetchNoteList() async {
    final response = await http.get(Uri.parse('${Constants.baseURL}/note/list'),
        headers: {"Authorization": "Bearer ${Constants.accessToken}"});

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('노트를 불러오지 못했습니다.');
    }
  }

  static Future<Map> fetchNote({required int noteId}) async {
    final response = await http.get(
        Uri.parse('${Constants.baseURL}/note/$noteId'),
        headers: basicHeaders);

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('노트를 불러오지 못했습니다.');
    }
  }

  static Future addNote({required String content, String title = ""}) async {
    final data = {
      "categories_id": 0,
      "content": content,
      "title": title,
      "type": "keyword"
    };
    final response = await http.post(
      Uri.parse('${Constants.baseURL}/note/add'),
      headers: basicHeaders,
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('노트를 저장하지 못했습니다.');
    }
  }

  static Future editNote(
      {required int noteId, required String content, String title = ""}) async {
    final data = {"content": content, "title": title};
    final response = await http.put(
      Uri.parse('${Constants.baseURL}/note/$noteId/edit'),
      headers: basicHeaders,
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('노트를 수정하지 못했습니다.');
    }
  }

  static Future deleteNote({required int noteId}) async {
    final response = await http.delete(
      Uri.parse('${Constants.baseURL}/note/$noteId/delete'),
      headers: {"Authorization": "Bearer ${Constants.accessToken}"},
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('노트를 삭제하지 못했습니다.');
    }
  }
}
