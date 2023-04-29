import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  final String accessToken, refreshToken, expiration;

  User({
    required this.accessToken,
    required this.refreshToken,
    required this.expiration,
  });

  User.fromJson(Map json)
      : accessToken = json["accessToken"],
        refreshToken = json["refreshToken"],
        expiration = DateTime.now().add(const Duration(minutes: 28)).toString();

  Map toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "expiration": expiration
      };
}
