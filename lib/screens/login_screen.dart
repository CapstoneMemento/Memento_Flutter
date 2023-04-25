import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memento_flutter/api/user_api.dart';
import 'package:memento_flutter/model/user.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User user = User();
  var idController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 비동기로 flutter secure storage 정보 불러오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserInfo();
    });
  }

  void getUserInfo() async {
    // 사용자 정보 불러오기
    final userInfo = await user.getUserInfo();

    if (userInfo != null) {
      if (mounted) {
        // 로그인한 사용자이면 홈으로 이동
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => NavigationBarWidget()),
            (route) => false);
      }
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

                    // 사용자 정보를 storage에 저장
                    await user.writeUserInfo(jsonEncode(response));

                    // 홈으로 이동
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => NavigationBarWidget()),
                        (route) => false);
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
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

class LoginField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const LoginField(
      {required this.controller,
      required this.hintText,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: const BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.all(Radius.circular(100))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                obscureText: obscureText,
                controller: controller,
                style: CustomTheme.themeData.textTheme.bodyMedium,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
