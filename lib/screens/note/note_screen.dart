import 'package:flutter/material.dart';
import 'package:memento_flutter/api/note_api.dart';

import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/list_button.dart';
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
  bool isEditing = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 노트 불러오기
    NoteAPI.fetchNote(noteId: widget.noteId).then((result) => {
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
            // 노트 수정 중이면 수정 취소
            if (isEditing) {
              setState(() {
                isEditing = false;
              });
            } else {
              // 노트 조회 중이면 내 암기장으로 이동
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => NavigationBarWidget(
                            selectedIndex: 0,
                          )),
                  (route) => false);
            }
          },
        ),
        actions: getActionWidget(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: getBodyWidget(context)),
        ),
      ),
    );
  }

  List<Widget> getBodyWidget(BuildContext context) {
    return isEditing
        ? [
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
          ]
        : [
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
          ];
  }

  List<Widget> getActionWidget(BuildContext context) {
    final saveButton = TextButton(
      child: const Text("저장"),
      onPressed: () async {
        final editedTitle = titleController.text;
        final editedContent = contentController.text;
        // 노트 수정 DB에 반영
        await NoteAPI.editNote(
            noteId: widget.noteId, content: editedContent, title: editedTitle);
        setState(() {
          title = editedTitle;
          content = editedContent;
          isEditing = false;
        });
      },
    );

    final editButton = TextButton(
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
    );

    final deleteButton = TextButton(
      child: const Text("삭제"),
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
                                builder: (context) => NavigationBarWidget(
                                      selectedIndex: 0,
                                    )),
                            (route) => false);
                      }
                    },
                  ),
                ],
              )),
    );

    return isEditing ? [saveButton] : [editButton, deleteButton];
  }

  void onTapEditNote() async {
    // 노트 수정 모드
    setState(() {
      titleController.text = title;
      contentController.text = content;
      isEditing = true;
    });
    // Dialog 닫기
    Navigator.of(context).pop();
  }

  void onTapEditKeyword() async {
    // 키워드 수정으로 이동
  }
}
