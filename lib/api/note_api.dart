import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memento_flutter/api/user_api.dart';
import 'package:memento_flutter/config/constants.dart';
import 'package:memento_flutter/utility/storage.dart';

class NoteAPI {
  static Future fetchNoteList() async {
    final accessToken = await Storage.getAccessToken();
    final response = await http.get(Uri.parse('${Constants.baseURL}/note/list'),
        headers: {"Authorization": "Bearer $accessToken"});

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 401) {
      await UserAPI.refreshToken();
      await fetchNoteList();
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('노트를 불러오지 못했습니다.');
    }
  }

  static Future fetchNote({required int noteId}) async {
    final accessToken = await Storage.getAccessToken();
    final response = await http
        .get(Uri.parse('${Constants.baseURL}/note/$noteId'), headers: {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 401) {
      await UserAPI.refreshToken();
      await fetchNote(noteId: noteId);
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('노트를 불러오지 못했습니다.');
    }
  }

  static Future addNote({required String content, String title = ""}) async {
    final accessToken = await Storage.getAccessToken();
    final data = {
      "categories_id": 0,
      "content": content,
      "title": title,
      "type": "keyword"
    };
    final response = await http.post(
      Uri.parse('${Constants.baseURL}/note/add'),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else if (response.statusCode == 401) {
      await UserAPI.refreshToken();
      await addNote(content: content, title: title);
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('노트를 저장하지 못했습니다.');
    }
  }

  static Future editNote(
      {required int noteId, required String content, String title = ""}) async {
    final accessToken = await Storage.getAccessToken();
    final data = {"content": content, "title": title};
    final response = await http.put(
      Uri.parse('${Constants.baseURL}/note/$noteId/edit'),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      await UserAPI.refreshToken();
      await editNote(noteId: noteId, content: content, title: title);
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('노트를 수정하지 못했습니다.');
    }
  }

  static Future deleteNote({required int noteId}) async {
    final accessToken = await Storage.getAccessToken();
    final response = await http.delete(
      Uri.parse('${Constants.baseURL}/note/$noteId/delete'),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      await UserAPI.refreshToken();
      await deleteNote(noteId: noteId);
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('노트를 삭제하지 못했습니다.');
    }
  }
}
