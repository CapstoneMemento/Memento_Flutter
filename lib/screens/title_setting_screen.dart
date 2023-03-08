import 'package:flutter/material.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';

class TitleSettingScreen extends StatelessWidget {
  final List<List<dynamic>> selectedText;

  TitleSettingScreen({required this.selectedText});

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
          const TextField(
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              border: OutlineInputBorder(),
              labelText: "판례 제목을 입력하세요",
              labelStyle: TextStyle(fontSize: 14),
            ),
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
          SelectableText.rich(
            TextSpan(
                children: selectedText
                    .map((e) => TextSpan(
                        text: e[0],
                        style: e[1] ? highlightStyle : const TextStyle()))
                    .toList()),
            toolbarOptions: const ToolbarOptions(selectAll: false),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 암기장 / 목차 지정
        },
        backgroundColor: CustomTheme.themeData.primaryColor,
        child: const Text("다음"),
      ),
    );
  }
}
