import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memento_flutter/api/user_api.dart';
import 'package:memento_flutter/model/user.dart';
import 'package:memento_flutter/provider/user_provider.dart';
import 'package:memento_flutter/screen/register_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/utility/storage.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/login_field.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var idController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Storage.readData(key: "userInfo").then((value) async {
      // 사용자 정보가 있으면 (이미 로그인 한 사용자이면) 홈 화면으로 이동
      if (value != null) {
        // 토큰 재발급
        await refreshToken();
      }
    });
  }

  // 30분마다 토큰 재발급
  Future refreshToken() async {
    final json = await UserAPI.refreshToken();

    // refreshToken이 만료되지 않았으면
    if (json != null) {
      // storage 사용자 정보 업데이트
      final userJson = User.fromJson(json).toJson();
      await Storage.writeJson(key: "userInfo", json: userJson);
      // 홈 화면으로 이동
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => NavigationBarWidget()),
            (route) => false);
      }
    } else {
      // refreshToken도 만료됐으면
      // Storage 사용자 정보 삭제
      await Storage.deleteData(key: "userInfo");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/images/logo_no_back.png",
                width: 120,
              ),
              const SizedBox(
                height: 20,
              ),
              LoginField(
                controller: idController,
                hintText: "아이디",
              ),
              const SizedBox(
                height: 20,
              ),
              LoginField(
                obscureText: true,
                controller: passwordController,
                hintText: "비밀번호",
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () async {
                    // 로그인 요청
                    final response = await UserAPI.login(
                        userId: idController.text,
                        password: passwordController.text);

                    if (response == null) {
                      // 아이디 또는  비밀번호 불일치
                      showDialog(
                          context: context,
                          builder: ((context) => AlertDialog(
                                contentPadding: const EdgeInsets.all(16),
                                content: Text(
                                  "아이디 또는 비밀번호가\n일치하지 않습니다.",
                                  textAlign: TextAlign.center,
                                  style: CustomTheme
                                      .themeData.textTheme.bodyMedium,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("확인"))
                                ],
                              )));
                    } else {
                      // 사용자 정보를 storage에 저장
                      final userJson = User.fromJson(response).toJson();
                      Storage.writeJson(key: "userInfo", json: userJson);

                      // 홈으로 이동
                      if (mounted) {
                        // state 설정
                        final userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        userProvider.setUser(json: userJson);

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => NavigationBarWidget()),
                            (route) => false);
                      }
                    }
                  },
                  child: Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: CustomTheme.themeData.primaryColor,
                          borderRadius: BorderRadius.circular(100)),
                      child: const Text(
                        "로그인",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ))),
              TextButton(
                child: Text(
                  "회원가입",
                  style: TextStyle(color: CustomTheme.themeData.primaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RegisterScreen()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
