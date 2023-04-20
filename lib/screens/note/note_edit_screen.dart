import 'package:flutter/material.dart';
import 'package:memento_flutter/api/note_api.dart';
import 'package:memento_flutter/screens/note/keyword_edit_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';

class NoteEditScreen extends StatefulWidget {
  final int noteId;
  String title;
  String content;

  NoteEditScreen(
      {required this.noteId, required this.title, required this.content});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // title, content 설정
    setState(() {
      titleController.text = widget.title;
      contentController.text = widget.content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        leading: const BackIconButton(),
        actions: [
          TextButton(
            child: const Text("저장"),
            onPressed: () async {
              final editedTitle = titleController.text;
              final editedContent = contentController.text;

              // 노트 수정 DB에 반영
              // 키워드 수정으로 이동
              NoteAPI.editNote(
                      noteId: widget.noteId,
                      content: editedContent,
                      title: editedTitle)
                  .then((_) => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => KeywordEditScreen(
                          noteId: widget.noteId,
                          // ignore: prefer_const_literals_to_create_immutables
                          selectedIndex: <Map>[],
                          content: widget.content))));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextField(
              controller: titleController,
              style: CustomTheme.themeData.textTheme.titleSmall,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                border: OutlineInputBorder(),
                hintText: "판례 제목을 입력하세요",
                hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              maxLines: 100,
              style: CustomTheme.themeData.textTheme.bodyMedium,
              controller: contentController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "판례를 입력하세요",
                hintStyle: TextStyle(fontSize: 14),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
