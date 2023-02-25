import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:memento_flutter/screens/home.dart';
import 'package:memento_flutter/themes/custom_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 다음 함수가 실행될 때까지 기다린다.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes',
      theme: CustomTheme.themeData,
      home: const Home(),
    );
  }
}
