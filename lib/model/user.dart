import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  String id;
  String nickname;

  User({this.id = "", this.nickname = ""});

  final storage = const FlutterSecureStorage();

  Future getUserInfo() async {
    final stringData = await storage.read(key: "userInfo");

    if (stringData != null) {
      return jsonDecode(stringData);
    }
    return null;
  }

  Future getAccessToken() async {
    final userInfo = await getUserInfo();

    if (userInfo != null) {
      return userInfo["accessToken"];
    }
    return null;
  }

  Future writeUserInfo(String value) async {
    await storage.write(key: "userInfo", value: value);
  }
}
