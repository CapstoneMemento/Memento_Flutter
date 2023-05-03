import 'package:flutter/material.dart';
import 'package:memento_flutter/api/search_api.dart';
import 'package:memento_flutter/screen/search/search_note_edit_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/loading.dart';

class SearchNoteScreen extends StatefulWidget {
  final Map<String, dynamic> caseInfo;

  const SearchNoteScreen({required this.caseInfo});

  @override
  State<SearchNoteScreen> createState() => _SearchNoteScreenState();
}

class _SearchNoteScreenState extends State<SearchNoteScreen> {
  bool isLoading = false;
  String main = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(leading: BackIconButton()),
      body: isLoading
          ? Loading()
          : FutureBuilder(
              future: SearchAPI.fetchContent(caseId: widget.caseInfo["number"]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  main = addLineBreak(snapshot.data?["main"]);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data?["title"],
                          style: CustomTheme.themeData.textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "판시사항",
                          style: CustomTheme.themeData.textTheme.titleSmall,
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        getStyledText(snapshot.data?["sentence"]),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "판결요지",
                          style: CustomTheme.themeData.textTheme.titleSmall,
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        getStyledText(snapshot.data?["main"]),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "관련 조문",
                          style: CustomTheme.themeData.textTheme.titleSmall,
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        getStyledText(snapshot.data?["provision"]),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "판결 이유",
                          style: CustomTheme.themeData.textTheme.titleSmall,
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        getStyledText(snapshot.data?["reason"]),
                        const SizedBox(
                          height: 70,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Loading();
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Text(
          "저장",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        onPressed: () async {
          if (main.isEmpty) {
            // 저장할 판결 요지가 없습니다.
          } else {
            // 노트 수정 화면으로 이동
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SearchNoteEditScreen(content: main)));
          }
        },
      ),
    );
  }

  Text getStyledText(String value) {
    return Text(
      addLineBreak(value),
      style: const TextStyle(height: 2),
    );
  }

  String addLineBreak(String value) {
    return value.replaceAll("<br/>", "\n");
  }
}
