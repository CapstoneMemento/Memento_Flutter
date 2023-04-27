import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:memento_flutter/api/user_api.dart';
import 'package:memento_flutter/config/constants.dart';
import 'package:memento_flutter/utility/storage.dart';

class FileAPI {
  static Future uploadFile({required File imageFile}) async {
    final accessToken = await Storage.getAccessToken();

    final uri = Uri.parse('${Constants.baseURL}/file/upload');
    final request = http.MultipartRequest("POST", uri);
    request.files
        .add(await http.MultipartFile.fromPath("file", imageFile.path));
    request.headers['Authorization'] = "Bearer $accessToken";

    final response = await request.send();

    if (response.statusCode == 200) {
      return response.stream.bytesToString();
    } else if (response.statusCode == 401) {
      await UserAPI.refreshToken();
      await uploadFile(imageFile: imageFile);
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('노트를 불러오지 못했습니다.');
    }
  }
}
