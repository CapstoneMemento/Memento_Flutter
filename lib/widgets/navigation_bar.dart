import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memento_flutter/api/user_api.dart';
import 'package:memento_flutter/model/user.dart';
import 'package:memento_flutter/screen/login_screen.dart';

import 'package:memento_flutter/screen/note/note_list_screen.dart';
import 'package:memento_flutter/screen/quiz/quiz_start_screen.dart';
import 'package:memento_flutter/screen/search/search_screen.dart';
import 'package:memento_flutter/screen/setting_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/utility/storage.dart';
import 'package:memento_flutter/widgets/app_bar/main_app_bar.dart';
import 'package:memento_flutter/widgets/modal_bottom_sheet.dart';

// storage에 userInfo가 없으면 LoginScreen으로 이동

class NavigationBarWidget extends StatefulWidget {
  int selectedIndex;

  NavigationBarWidget({this.selectedIndex = 0});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  static const List<String> appBarTitle = ["내 암기장", "판례 검색", "퀴즈", "설정"];
  static List<Widget> bodyOptions = [
    const NoteListScreen(),
    const SearchScreen(),
    const QuizStartScreen(),
    const SettingScreen()
  ];
  static const List<Widget> floatingButtonOptions = [
    ModalBottomSheet(),
    SizedBox.shrink(),
    SizedBox.shrink(),
    SizedBox.shrink()
  ];

  @override
  void initState() {
    super.initState();
    startTokenRefreshTimer();
  }

  // 30분마다 토큰 재발급
  Future startTokenRefreshTimer() async {
    Timer.periodic(const Duration(minutes: 28), (timer) async {
      final json = await UserAPI.refreshToken();

      // refreshToken이 만료되지 않았으면
      if (json != null) {
        // storage 사용자 정보 업데이트
        final userJson = User.fromJson(json).toJson();
        await Storage.writeJson(key: "userInfo", json: userJson);
      } else {
        // refreshToken도 만료되면
        // Storage 사용자 정보 삭제
        await Storage.deleteData(key: "userInfo");
        // 로그인 화면으로 돌아가기
        showDialog(
            context: context,
            builder: ((context) => AlertDialog(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    "로그인 만료",
                    style: CustomTheme.themeData.textTheme.titleSmall,
                  ),
                  content: const Text("로그인이 만료되었습니다.\n다시 로그인 해주세요.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false);
                        },
                        child: const Text("확인"))
                  ],
                )));
      }
    });
  }

  void _onTap(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppBar(
          title: Text(appBarTitle.elementAt(widget.selectedIndex)),
        ),
        body: bodyOptions.elementAt(widget.selectedIndex),
        floatingActionButton:
            floatingButtonOptions.elementAt(widget.selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: widget.selectedIndex,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "내암기장"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "판례검색"),
            BottomNavigationBarItem(icon: Icon(Icons.quiz), label: "퀴즈"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "설정"),
          ],
          fixedColor: CustomTheme.themeData.primaryColor,
          onTap: _onTap,
        ));
  }
}
