import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/note_list_screen.dart';
import 'package:memento_flutter/screens/quiz/quiz_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class QuizCategoryScreen extends StatelessWidget {
  final String subjectTitle;

  QuizCategoryScreen({required this.subjectTitle});

  // DB에서 목차 정보 불러오기
  final List<Map<String, dynamic>> categoryList = [
    {"id": "1", "title": "민법총칙", "caseNum": 10},
    {"id": "2", "title": "물권법", "caseNum": 12},
    {"id": "3", "title": "채권 총론", "caseNum": 34},
    {"id": "4", "title": "채권각론", "caseNum": 22},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          title: Text(subjectTitle),
          leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => QuizScreen()));
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black)),
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
                                    builder: (context) => NoteListScreen(
                                          category: e["title"],
                                        )));
                          },
                        ),
                      ))
                  .toList()),
        ));
  }
}
