import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memento_flutter/api/user_api.dart';
import 'package:memento_flutter/model/user.dart';
import 'package:memento_flutter/provider/user_provider.dart';
import 'package:memento_flutter/screen/login_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/utility/storage.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    startTokenRefreshTimer();
  }

  // 30분마다 토큰 재발급
  void startTokenRefreshTimer() {
    Timer.periodic(const Duration(minutes: 28), (timer) async {
      final json = await UserAPI.refreshToken();

      if (json != null) {
        // storage 사용자 정보 업데이트
        final userJson = User.fromJson(json).toJson();
        await Storage.writeJson(key: "userInfo", json: userJson);
      } else {
        // 토큰이 만료되면 로그인 화면으로 이동
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UserProvider(),
        child: MaterialApp(
          title: 'My Notes',
          theme: CustomTheme.themeData,
          home: const LoginScreen(),
        ));
  }
}
