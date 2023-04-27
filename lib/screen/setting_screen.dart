import 'package:flutter/material.dart';
import 'package:memento_flutter/api/user_api.dart';
import 'package:memento_flutter/provider/user_provider.dart';
import 'package:memento_flutter/screen/login_screen.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // state 삭제
        context.read<UserProvider>().deleteUser();
        // 로그아웃 후 로그인 화면으로 이동
        UserAPI.logout().then((_) => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 1,
          color: Colors.black12,
        ))),
        child: const Padding(padding: EdgeInsets.all(14), child: Text("로그아웃")),
      ),
    );
  }
}
