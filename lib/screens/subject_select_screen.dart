// 과목, 목차 지정 화면
import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/note_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';

class SubjectSelectScreen extends StatefulWidget {
  String noteId;

  SubjectSelectScreen({required this.noteId});

  @override
  State<SubjectSelectScreen> createState() => _SubjectSelectScreenState();
}

class _SubjectSelectScreenState extends State<SubjectSelectScreen> {
  final List<Map<String, dynamic>> subjects = [
    {"id": "1", "title": "과목1", "caseNum": 22},
    {"id": "2", "title": "과목2", "caseNum": 43},
    {"id": "3", "title": "과목3", "caseNum": 20},
  ];

  final List<Map<String, dynamic>> categories = [
    {"id": "1", "title": "목차1", "caseNum": 22},
    {"id": "2", "title": "목차2", "caseNum": 43},
    {"id": "3", "title": "목차3", "caseNum": 20},
  ];

  var isSubject = true;

  @override
  Widget build(BuildContext context) {
    void goNext({required String id}) {
      if (isSubject) {
        // 선택한 과목의 목차로 넘어가기
        setState(() {
          isSubject = false;
        });
      } else {
        // 목차 id DB에 저장
        // 노트 화면으로 이동
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: ((context) => NavigationBarWidget())),
            (route) => false);
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => NoteScreen(
                  noteId: widget.noteId,
                ))));
      }
    }

    return Scaffold(
      appBar: const BaseAppBar(
        leading: BackIconButton(),
        actions: [
          Icon(
            Icons.close,
            color: Colors.black,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isSubject ? "암기장을 선택하세요" : "목차를 선택하세요",
              style: CustomTheme.themeData.textTheme.titleMedium,
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: ListView(
                  children: (isSubject ? subjects : categories)
                      .map((e) => Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        width: 1, color: Colors.black26))),
                            child: ListTile(
                              title: Text(e["title"]),
                              subtitle: Text("저장한 판례 ${e["caseNum"]}개"),
                              onTap: () {
                                goNext(id: e["id"]);
                              },
                            ),
                          ))
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
