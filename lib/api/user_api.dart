import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:memento_flutter/config/constants.dart';

class UserAPI {
  static const storage = FlutterSecureStorage();

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

  static Future refreshToken(
      {required String accessToken, required String refreshToken}) async {
    final data = {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "grantType": "string"
    };
    final response = await http.post(
        Uri.parse('${Constants.baseURL}/users/reissue'),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('토큰을 재발급하지 못했습니다.');
    }
  }

  static Future logout() async {
    final userInfo = await storage.read(key: "userInfo");
    final refreshToken = jsonDecode(userInfo!)["refreshToken"];
    final accessToken = jsonDecode(userInfo)["accessToken"];

    final response = await http
        .delete(Uri.parse('${Constants.baseURL}/users/reissue'), headers: {
      "Authorization": "Bearer $accessToken",
      "RefreshToken": refreshToken
    });

    if (response.statusCode == 200) {
      // 저장소에서 사용자 정보 삭제
      await storage.delete(key: "userInfo");

      return response;
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('로그아웃 실패');
    }
  }
}
