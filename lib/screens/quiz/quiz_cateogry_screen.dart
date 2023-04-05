import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/quiz/keyword_quiz_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class QuizCategoryScreen extends StatelessWidget {
  final String subjectTitle;

  QuizCategoryScreen({required this.subjectTitle});

  // DB에서 목차 정보 불러오기
  final List<Map<String, dynamic>> categoryList = [
    {"id": "1", "title": "특허법 총칙", "caseNum": 10},
    {"id": "2", "title": "발명 및 실시", "caseNum": 12},
    {"id": "3", "title": "특허심사", "caseNum": 34},
    {"id": "4", "title": "실체심사", "caseNum": 22},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          title: Text(subjectTitle),
          leading: const BackIconButton(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
              children: categoryList
                  .map((e) => Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 1, color: Colors.black26))),
                        child: ListTile(
                          title: Text(e["title"]),
                          subtitle: Text("저장한 판례 ${e["caseNum"]}개"),
                          trailing: CircularPercentIndicator(
                            radius: 24,
                            lineWidth: 5.0,
                            percent: 0.6,
                            center: const Text(
                              "60%",
                              style: TextStyle(fontSize: 12),
                            ),
                            progressColor: CustomTheme.themeData.primaryColor,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const KeywordQuizScreen()));
                          },
                        ),
                      ))
                  .toList()),
        ));
  }
}
