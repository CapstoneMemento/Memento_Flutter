import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/home.dart';
import 'package:memento_flutter/screens/quiz_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';
import 'package:memento_flutter/widgets/modal_bottom_sheet.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({super.key});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int selectedIndex = 0;
  static const List<String> appBarTitle = ["내 암기장", "", "퀴즈"];
  static List<Widget> bodyOptions = [const Home(), const Home(), QuizScreen()];
  static const List<Widget> floatingButtonOptions = [
    ModalBottomSheet(),
    ModalBottomSheet(),
    ModalBottomSheet()
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          title: Text(appBarTitle.elementAt(selectedIndex)),
        ),
        body: bodyOptions.elementAt(selectedIndex),
        floatingActionButton: floatingButtonOptions.elementAt(selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "내암기장"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "판례검색"),
            BottomNavigationBarItem(icon: Icon(Icons.quiz), label: "퀴즈"),
          ],
          fixedColor: CustomTheme.themeData.primaryColor,
          onTap: _onItemTapped,
        ));
  }
}
