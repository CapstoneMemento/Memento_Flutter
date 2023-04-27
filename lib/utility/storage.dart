import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const storage = FlutterSecureStorage();

  static Future readData({required String key}) async {
    return await storage.read(key: "userInfo");
  }

  static void writeJson({required String key, required Map json}) async {
    await storage.write(key: "userInfo", value: jsonEncode(json));
  }

  static void writeString({required String key, required String value}) async {
    await storage.write(key: "userInfo", value: value);
  }

  static void deleteData({required String key}) async {
    await storage.delete(key: key);
  }

  static Future getAccessToken() async {
    final userInfo = await Storage.readData(key: "userInfo");
    final accessToken = userInfo["accessToken"];

    return accessToken;
  }
}
