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
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      // storage 사용자 정보 업데이트
      Storage.writeJson(key: "userInfo", json: json as Map);

      return json;
    } else if (response.statusCode == 401) {
      // storage에서 만료된 토큰 삭제
      Storage.deleteData(key: "userInfo");
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
        .delete(Uri.parse('${Constants.baseURL}/users/refreshToken'), headers: {
      "Authorization": "Bearer $accessToken",
      "RefreshToken": "Bearer $refreshToken"
    });

    if (response.statusCode == 200) {
      // 저장소에서 사용자 정보 삭제
      Storage.deleteData(key: "userInfo");

      return response;
    } else if (response.statusCode == 401) {
      await refreshToken();
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('로그아웃 실패');
    }
  }
}
