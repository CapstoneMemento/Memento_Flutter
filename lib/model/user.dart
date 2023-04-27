import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  final String userId, nickname, accessToken, refreshToken;

  User(
      {required this.userId,
      required this.nickname,
      required this.accessToken,
      required this.refreshToken});

  User.fromJson(Map json)
      : userId = json["userid"],
        nickname = json["nickname"],
        accessToken = json["accessToken"],
        refreshToken = json["refreshToken"];
}
