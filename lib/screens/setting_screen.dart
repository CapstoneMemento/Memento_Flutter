import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 로그아웃
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 1,
          color: Colors.black12,
        ))),
        child: const Padding(padding: EdgeInsets.all(14), child: Text("로그아웃")),
      ),
    );
  }
}
