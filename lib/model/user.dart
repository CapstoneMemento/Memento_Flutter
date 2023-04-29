import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  final String userid, nickname, accessToken, refreshToken, expiration;

  User({
    required this.userid,
    required this.nickname,
    required this.accessToken,
    required this.refreshToken,
    required this.expiration,
  });

  User.fromJson(Map json)
      : userid = json["userid"],
        nickname = json["nickname"],
        accessToken = json["accessToken"],
        refreshToken = json["refreshToken"],
        expiration = DateTime.now().add(const Duration(minutes: 28)).toString();

  Map toJson() => {
        "userid": userid,
        "nickname": nickname,
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "expiration": expiration
      };
}
