import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const storage = FlutterSecureStorage();

  static Future readData({required String key}) async {
    final data = await storage.read(key: key);

    if (data == null) {
      return null;
    }

    return jsonDecode(data);
  }

  static Future writeJson({required String key, required Map json}) async {
    await storage.write(key: key, value: jsonEncode(json));
  }

  static Future writeString(
      {required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  static Future deleteData({required String key}) async {
    await storage.delete(key: key);
  }

  static Future getAccessToken() async {
    final userInfo = await Storage.readData(key: "userInfo");

    if (userInfo == null) {
      return null;
    }

    return userInfo["accessToken"];
  }
}
