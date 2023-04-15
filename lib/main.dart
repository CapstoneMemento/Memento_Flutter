import 'package:flutter/material.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';
import 'package:memento_flutter/themes/custom_theme.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes',
      theme: CustomTheme.themeData,
      home: NavigationBarWidget(),
    );
  }
}
