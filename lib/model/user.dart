import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  final String accessToken, refreshToken;

  User({
    required this.accessToken,
    required this.refreshToken,
  });

  User.fromJson(Map json)
      : accessToken = json["accessToken"],
        refreshToken = json["refreshToken"];

  Map toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}
