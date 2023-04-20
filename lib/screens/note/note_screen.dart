import 'package:flutter/material.dart';
import 'package:memento_flutter/api/keyword_api.dart';
import 'package:memento_flutter/api/note_api.dart';
import 'package:memento_flutter/screens/note/keyword_edit_screen.dart';
import 'package:memento_flutter/screens/note/note_edit_screen.dart';

import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/keyword_text.dart';
import 'package:memento_flutter/widgets/list_button.dart';
import 'package:memento_flutter/widgets/loading.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';

class NoteScreen extends StatefulWidget {
  final int noteId; // id로 노트 내용 불러오기

  const NoteScreen({required this.noteId});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late List selectedText;
  String content = "";
  String title = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // 노트 불러오기
    NoteAPI.fetchNote(noteId: widget.noteId).then((result) => {
          setState(() {
            title = result["title"];
            content = result["content"];
          })
        });
    KeywordAPI.getKeywordList(widget.noteId).then((result) => {
          setState(() {
            selectedText = result;
            isLoading = false;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              // 노트 조회 중이면 내 암기장으로 이동
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => NavigationBarWidget(
                            selectedIndex: 0,
                          )),
                  (route) => false);
            },
          ),
          actions: [
            TextButton(
              child: const Text("수정"),
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    ListButton(
                        icon: const Icon(Icons.notes),
                        text: "노트 수정",
                        onTap: onTapEditNote),
                    ListButton(
                        icon: const Icon(Icons.abc),
                        text: "키워드 수정",
                        onTap: onTapEditKeyword)
                  ]),
                ),
              ),
            ),
            TextButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        content: const Text("이 노트를 삭제할까요?"),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('취소'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text('확인'),
                            onPressed: () async {
                              // 노트 삭제
                              await NoteAPI.deleteNote(noteId: widget.noteId);

                              if (mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NavigationBarWidget(
                                              selectedIndex: 0,
                                            )),
                                    (route) => false);
                              }
                            },
                          ),
                        ],
                      )),
              child: const Text("삭제"),
            )
          ],
        ),
        body: isLoading
            ? Loading()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: CustomTheme.themeData.textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        KeywordText(selectedText: selectedText)
                      ]),
                ),
              ));
  }

  void onTapEditNote() async {
    // 노트 수정 화면으로 이동
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NoteEditScreen(
            noteId: widget.noteId, title: title, content: content)));
  }

  void onTapEditKeyword() {
    // 키워드 수정으로 이동
    KeywordAPI.getIndexList(widget.noteId)
        .then((result) => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => KeywordEditScreen(
                  noteId: widget.noteId,
                  content: content,
                  selectedIndex: result,
                ))));
  }
}
