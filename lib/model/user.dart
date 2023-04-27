import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  final String id, nickname, accessToken, refreshToken;

  User(
      {required this.id,
      required this.nickname,
      required this.accessToken,
      required this.refreshToken});

  User.fromJson(Map json)
      : id = json["id"],
        nickname = json["nickname"],
        accessToken = json["accessToken"],
        refreshToken = json["refreshToken"];
}
