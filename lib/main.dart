import 'package:flutter/material.dart';

import 'package:memento_flutter/themes/custom_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes',
      theme: CustomTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("내 암기장"),
          centerTitle: true,
          backgroundColor: Colors.white,
          titleTextStyle: CustomTheme.themeData.textTheme.titleLarge,
          elevation: 0,
        ),
      ),
    );
  }
}
