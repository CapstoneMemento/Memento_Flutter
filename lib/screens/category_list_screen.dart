import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/note_list_screen.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';

class CategoryListScreen extends StatelessWidget {
  // DB에서 목차 정보 불러오기
  final List<Map<String, dynamic>> categoryList = [
    {"id": "1", "title": "발명의 종류", "caseNum": 10},
    {"id": "2", "title": "PCT", "caseNum": 12}
  ];

  final String subject; // 이전 화면에서 선택한 과목

  CategoryListScreen({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          title: Text(subject),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
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
                          trailing: const Icon(Icons.playlist_add),
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
