import 'package:flutter/material.dart';
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
    checkUserInfo();
  }

  // 토큰이 만료되면 로그인 화면으로 이동
  void checkUserInfo() {
    Storage.readData(key: "userInfo").then((userInfo) => {
          if (userInfo == null)
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false)
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
