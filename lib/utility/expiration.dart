import 'package:memento_flutter/api/user_api.dart';
import 'package:memento_flutter/utility/storage.dart';

class Expiration {
  static void checkExpiration() async {
    final userInfo = await Storage.readData(key: "userInfo");
    final now = DateTime.now().toString();
    // 토큰이 만료되면 재발급
    if (now.compareTo(userInfo["expiration"]) < 0) {
      await UserAPI.refreshToken();
    }
  }
}
