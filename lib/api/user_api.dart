import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memento_flutter/config/constants.dart';
import 'package:memento_flutter/utility/expiration.dart';
import 'package:memento_flutter/utility/storage.dart';

class UserAPI {
  static Future login(
      {required String userId, required String password}) async {
    final data = {"userid": userId, "password": password};
    final response = await http.post(
        Uri.parse('${Constants.baseURL}/users/login'),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('로그인 하지 못했습니다..');
    }
  }

  static Future refreshToken() async {
    final userInfo = await Storage.readData(key: "userInfo");
    final accessToken = userInfo["accessToken"];
    final refreshToken = userInfo["refreshToken"];

    final response = await http
        .post(Uri.parse('${Constants.baseURL}/users/reissue'), headers: {
      "Authorization": "Bearer $accessToken",
      "RefreshToken": "Bearer $refreshToken",
    });

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('토큰을 재발급하지 못했습니다.');
    }
  }

  static Future logout() async {
    Expiration.checkExpiration();

    final userInfo = await Storage.readData(key: "userInfo");
    final accessToken = userInfo["accessToken"];
    final refreshToken = userInfo["refreshToken"];

    final response = await http
        .delete(Uri.parse('${Constants.baseURL}/users/logout'), headers: {
      "Authorization": "Bearer $accessToken",
      "RefreshToken": "Bearer $refreshToken"
    });

    if (response.statusCode == 200) {
      // 저장소에서 사용자 정보 삭제
      Storage.deleteData(key: "userInfo");

      return response;
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('로그아웃 실패');
    }
  }
}
