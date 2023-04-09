import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memento_flutter/config/constants.dart';

class NoteAPi {
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
}
