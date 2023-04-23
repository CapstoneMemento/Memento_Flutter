import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memento_flutter/config/constants.dart';

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
}
