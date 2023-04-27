import 'package:flutter/material.dart';
import 'package:memento_flutter/api/keyword_api.dart';
import 'package:memento_flutter/api/note_api.dart';
import 'package:memento_flutter/screen/note/note_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/keyword_text.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';

class TitleSettingScreen extends StatefulWidget {
  final int noteId;
  final String content;
  final List selectedText;

  const TitleSettingScreen(
      {required this.noteId,
      required this.selectedText,
      required this.content});

  @override
  State<TitleSettingScreen> createState() => _TitleSettingScreenState();
}

class _TitleSettingScreenState extends State<TitleSettingScreen> {
  String title = "";
  // 판례 제목
  final highlightStyle =
      TextStyle(backgroundColor: Colors.yellow.withOpacity(0.5));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            // 저장한 키워드 DB에서 삭제
            KeywordAPI.deleteKeyword(noteId: widget.noteId)
                .then((_) => Navigator.of(context).pop());
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.black,
            onPressed: () async {
              // 저장한 키워드 DB에서 삭제
              await KeywordAPI.deleteKeyword(noteId: widget.noteId);

              if (mounted) {
                // 홈에서 노트 화면으로 이동
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => NavigationBarWidget(
                        selectedIndex: 0,
                      ),
                    ),
                    (route) => false);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NoteScreen(
                      noteId: widget.noteId,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              border: OutlineInputBorder(),
              labelText: "판례 제목을 입력하세요",
              labelStyle: TextStyle(fontSize: 14),
            ),
            onChanged: (value) {
              title = value;
            },
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
          Expanded(
              child: SingleChildScrollView(
                  child: KeywordText(selectedText: widget.selectedText)))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomTheme.themeData.primaryColor,
        child: const Text("다음"),
        onPressed: () async {
          // noteId로 title 저장
          await NoteAPI.editNote(
              noteId: widget.noteId, content: widget.content, title: title);

          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => NoteScreen(
                          noteId: widget.noteId,
                        )),
                (route) => false);
          }
        },
      ),
    );
  }
}
