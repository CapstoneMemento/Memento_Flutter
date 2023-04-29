import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  final String userId, nickname, accessToken, refreshToken, expiration;

  User({
    required this.userId,
    required this.nickname,
    required this.accessToken,
    required this.refreshToken,
    required this.expiration,
  });

  User.fromJson(Map json)
      : userId = json["userid"],
        nickname = json["nickname"],
        accessToken = json["accessToken"],
        refreshToken = json["refreshToken"],
        expiration = DateTime.now().add(const Duration(minutes: 28)).toString();
}
