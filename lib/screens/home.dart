import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/category_list_screen.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';
import 'package:memento_flutter/widgets/modal_bottom_sheet.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // DB에서 과목 정보 불러오기
  final List<Map<String, dynamic>> subjectList = [
    {"id": "1", "title": "특허법", "caseNum": 22}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: Text("내 암기장"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
            children: subjectList
                .map((e) => Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              top:
                                  BorderSide(width: 1, color: Colors.black26))),
                      child: ListTile(
                        title: Text(e["title"]),
                        subtitle: Text("저장한 판례 ${e["caseNum"]}개"),
                        trailing: const Icon(Icons.notifications_none),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryListScreen()));
                        },
                      ),
                    ))
                .toList()),
      ),
      floatingActionButton: const ModalBottomSheet(),
    );
  }
}
