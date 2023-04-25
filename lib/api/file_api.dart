import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:memento_flutter/config/constants.dart';

class FileAPI {
  static const storage = FlutterSecureStorage();

  static Future<String> uploadFile({required File imageFile}) async {
    final uri = Uri.parse('${Constants.baseURL}/file/upload');
    final request = http.MultipartRequest("POST", uri);
    request.files
        .add(await http.MultipartFile.fromPath("file", imageFile.path));
    request.headers['Authorization'] =
        "Bearer ${storage.read(key: "userInfo")}";

    final response = await request.send();

    if (response.statusCode == 200) {
      return response.stream.bytesToString();
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('노트를 불러오지 못했습니다.');
    }
  }
}
