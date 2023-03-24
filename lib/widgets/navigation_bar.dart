import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/home.dart';
import 'package:memento_flutter/screens/quiz/quiz_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';
import 'package:memento_flutter/widgets/modal_bottom_sheet.dart';

class NavigationBarWidget extends StatefulWidget {
  int selectedIndex;

  NavigationBarWidget({this.selectedIndex = 0});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  static const List<String> appBarTitle = ["내 암기장", "", "퀴즈"];
  static List<Widget> bodyOptions = [const Home(), const Home(), QuizScreen()];
  static const List<Widget> floatingButtonOptions = [
    ModalBottomSheet(),
    ModalBottomSheet(),
    ModalBottomSheet()
  ];

  void _onTap(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
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
