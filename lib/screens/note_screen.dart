import 'package:flutter/material.dart';
import 'package:memento_flutter/api/note_api.dart';

import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';

class NoteScreen extends StatefulWidget {
  final int noteId; // id로 노트 내용 불러오기

  const NoteScreen({required this.noteId});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  String content = "";
  String title = "";

  @override
  void initState() {
    super.initState();
    // 노트 불러오기
    final response = NoteAPi.fetchNote(noteId: widget.noteId).then((result) => {
          setState(
            () {
              title = result["title"];
              content = result["content"];
            },
          )
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
            // 내 암기장으로 이동
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
                            await NoteAPi.deleteNote(noteId: widget.noteId);

                            if (mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => NavigationBarWidget(
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            title,
            style: CustomTheme.themeData.textTheme.titleMedium,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            content,
          )
          // 실제로 사용할 위젯은 아래
          // KeywordText(selectedText: selectedText)
        ]),
      ),
    );
  }
}
