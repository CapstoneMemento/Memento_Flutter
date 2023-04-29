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

  void startTokenRefreshTimer() {
    Timer.periodic(const Duration(minutes: 29), (timer) async {
      final json = await UserAPI.refreshToken();

      // storage 사용자 정보 업데이트
      final userJson = User.fromJson(json).toJson();
      await Storage.writeJson(key: "userInfo", json: userJson);
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
