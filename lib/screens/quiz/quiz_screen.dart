import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/quiz/quiz_cateogry_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';

class QuizScreen extends StatelessWidget {
  // DB에서 과목 정보 불러오기
  final List<Map<String, dynamic>> subjectList = [
    {"id": "1", "title": "특허법", "caseNum": 22},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "과목을 선택하세요 ✍️",
            style: CustomTheme.themeData.textTheme.titleSmall,
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: ListView(
                children: subjectList
                    .map((e) => Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      width: 1, color: Colors.black26))),
                          child: ListTile(
                            title: Text(e["title"]),
                            subtitle: Text("저장한 판례 ${e["caseNum"]}개"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuizCategoryScreen(
                                            subjectTitle: e["title"],
                                          )));
                            },
                          ),
                        ))
                    .toList()),
          ),
        ],
      ),
    );
  }
}
