import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memento_flutter/config/constants.dart';

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
    } else if (response.statusCode == 500) {
      // 아이디 또는 비밀번호 불일치
      return null;
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('로그인 하지 못했습니다.');
    }
  }

  static Future register(
      {required String nickname,
      required String userId,
      required String password}) async {
    final data = {"nickname": nickname, "userid": userId, "password": password};
    final response = await http.post(
        Uri.parse('${Constants.baseURL}/users/register'),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 500) {
      // 모든 값이 입력되지 않음
      return null;
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('로그인 하지 못했습니다.');
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
    } else if (response.statusCode == 401) {
      // 저장소 정보 삭제하고 다시 로그인
      await Storage.deleteData(key: "userInfo");
      return null;
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('토큰을 재발급하지 못했습니다.');
    }
  }

  static Future logout() async {
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
      await Storage.deleteData(key: "userInfo");

      return response;
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('로그아웃 실패');
    }
  }
}
