import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/subject_select_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';
import 'package:memento_flutter/widgets/keyword_text.dart';

class TitleSettingScreen extends StatelessWidget {
  final List<Map<String, dynamic>> selectedText;

  TitleSettingScreen({required this.selectedText});

  late String title; // 판례 제목
  // 선택한 문자 text style
  final highlightStyle =
      TextStyle(backgroundColor: Colors.yellow.withOpacity(0.5));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        actions: [
          Icon(
            Icons.close,
            color: Colors.black,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              border: OutlineInputBorder(),
              labelText: "판례 제목을 입력하세요",
              labelStyle: TextStyle(fontSize: 14),
            ),
            onChanged: (value) {
              // 제목 지정
              title = value;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "선택한 내용",
            style: CustomTheme.themeData.textTheme.titleSmall,
          ),
          const SizedBox(
            height: 16,
          ),
          KeywordText(selectedText: selectedText)
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SubjectSelectScreen()));
        },
        backgroundColor: CustomTheme.themeData.primaryColor,
        child: const Text("다음"),
      ),
    );
  }
}
