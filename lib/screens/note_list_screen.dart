import 'package:flutter/material.dart';
import 'package:memento_flutter/themes/custom_theme.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black)),
          title: const Text(
            "발명의 종류",
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          titleTextStyle: CustomTheme.themeData.textTheme.titleLarge,
          elevation: 0,
          toolbarHeight: 60,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(children: [
            ListTile(
              title: Text(
                "발명의 완성",
                style: CustomTheme.themeData.textTheme.titleSmall,
              ),
              subtitle: const Text(
                  "송금의뢰인이 착오송금임을 이유로 거래은행을 통하여 혹은 수취은행에 직접 송금액의 반환을 요청.."),
              trailing: const Icon(Icons.add),
              onTap: () {
                // 해당 노트 화면으로 이동
              },
            ),
            ListTile(
              title: Text(
                "수치한정 발명의 의의",
                style: CustomTheme.themeData.textTheme.titleSmall,
              ),
              subtitle: const Text(
                  "송금의뢰인이 착오송금임을 이유로 거래은행을 통하여 혹은 수취은행에 직접 송금액의 반환을 요청.."),
              trailing: const Icon(Icons.add),
              onTap: () {
                // 해당 노트 화면으로 이동
              },
            ),
          ]),
        ));
  }
}
