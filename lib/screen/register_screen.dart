import 'package:flutter/material.dart';
import 'package:memento_flutter/api/user_api.dart';
import 'package:memento_flutter/screen/login_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/login_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var idController = TextEditingController();
  var passwordController = TextEditingController();
  var nicknameController = TextEditingController();
  var passwordCheckController = TextEditingController();
  var message = "";

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
                controller: nicknameController,
                hintText: "닉네임",
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
              LoginField(
                obscureText: true,
                controller: passwordCheckController,
                hintText: "비밀번호 확인",
              ),
              Text(
                message,
                style: const TextStyle(color: Colors.red),
              ),
              TextButton(
                  onPressed: () async {
                    final id = idController.text;
                    final password = passwordController.text;
                    final passwordCheck = passwordCheckController.text;
                    final nickname = nicknameController.text;
                    final isEmpty = id == "" ||
                        password == "" ||
                        passwordCheck == "" ||
                        nickname == "";

                    // 빈 값이 있으면 메시지 보이기
                    if (isEmpty) {
                      setState(() {
                        message = "*정보를 모두 입력해주세요.";
                      });
                      return;
                    }

                    // 비밀번호가 일치하지 않으면 메시지 보이기
                    if (password != passwordCheck) {
                      setState(() {
                        message = "*비밀번호가 일치하지 않습니다.";
                      });
                      return;
                    }

                    // 회원가입 요청
                    final response = UserAPI.register(
                        nickname: nickname, userId: id, password: password);

                    // 회원가입 완료 dialog
                    showDialog(
                        context: context,
                        builder: ((context) => AlertDialog(
                              contentPadding: const EdgeInsets.all(16),
                              content: const Text("회원가입이 완료되었습니다.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      // 로그인 화면으로 이동
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()),
                                          (route) => false);
                                    },
                                    child: const Text("확인"))
                              ],
                            )));
                  },
                  child: Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: CustomTheme.themeData.primaryColor,
                          borderRadius: BorderRadius.circular(100)),
                      child: const Text(
                        "회원가입",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ))),
              TextButton(
                  onPressed: () {
                    // 로그인 화면으로 이동
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  },
                  child: Text(
                    "로그인",
                    style: TextStyle(color: CustomTheme.themeData.primaryColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
