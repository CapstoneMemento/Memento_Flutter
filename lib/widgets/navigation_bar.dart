import 'package:flutter/material.dart';

import 'package:memento_flutter/screens/note_list_screen.dart';
import 'package:memento_flutter/screens/quiz/quiz_start_screen.dart';
import 'package:memento_flutter/screens/search/search_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/main_app_bar.dart';
import 'package:memento_flutter/widgets/modal_bottom_sheet.dart';

class NavigationBarWidget extends StatefulWidget {
  int selectedIndex;

  NavigationBarWidget({this.selectedIndex = 2});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  static const List<String> appBarTitle = ["내 암기장", "판례 검색", "퀴즈"];
  static List<Widget> bodyOptions = [
    const NoteListScreen(),
    const SearchScreen(),
    QuizStartScreen()
  ];
  static const List<Widget> floatingButtonOptions = [
    ModalBottomSheet(),
    SizedBox.shrink(),
    SizedBox.shrink()
  ];

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
          currentIndex: widget.selectedIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "내암기장"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "판례검색"),
            BottomNavigationBarItem(icon: Icon(Icons.quiz), label: "퀴즈"),
          ],
          fixedColor: CustomTheme.themeData.primaryColor,
          onTap: _onTap,
        ));
  }
}
