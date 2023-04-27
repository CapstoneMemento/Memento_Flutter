import 'package:flutter/material.dart';
import 'package:memento_flutter/provider/user_provider.dart';
import 'package:memento_flutter/screen/login_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UserProvider(),
        child: MaterialApp(
          title: 'My Notes',
          theme: CustomTheme.themeData,
          home: const LoginScreen(),
        ));
  }
}
