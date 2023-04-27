import 'package:flutter/material.dart';
import 'package:memento_flutter/api/keyword_api.dart';
import 'package:memento_flutter/api/note_api.dart';
import 'package:memento_flutter/screen/title_setting_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/main_app_bar.dart';
import 'package:memento_flutter/widgets/keyword_select.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';

class KeywordSelectScreen extends StatelessWidget {
  final int noteId;
  final String content; // 노트 본문

  KeywordSelectScreen({
    required this.noteId,
    required this.content,
  });

  // 선택한 문자의 인덱스 {first, last, noteId}
  List selectedIndex = [];

  // 선택한 문자 {text, isKeyword}
  List selectedText = [];

  // 선택한 문자 TextStyle
  final highlightStyle =
      TextStyle(backgroundColor: Colors.yellow.withOpacity(0.5));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () {
                // 미리 저장한 노트 삭제
                NoteAPI.deleteNote(noteId: noteId)
                    .then((_) => Navigator.of(context).pop());
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                color: Colors.black,
                onPressed: () {
                  // 미리 저장한 노트 삭제
                  NoteAPI.deleteNote(noteId: noteId)
                      .then((_) => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => NavigationBarWidget(
                                    selectedIndex: 0,
                                  )),
                          (route) => false));
                },
              ),
            ]),
        body: KeywordSelect(
            selectedIndex: selectedIndex, noteId: noteId, content: content),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CustomTheme.themeData.primaryColor,
          child: const Text("다음"),
          onPressed: () {
            // selectedIndex 키워드 DB에 저장
            KeywordAPI.saveKeyword(selectedIndex).then((_) =>
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TitleSettingScreen(
                        noteId: noteId,
                        selectedText: KeywordAPI.sliceText(
                            content: content, selectedIndex: selectedIndex),
                        content: content))));
          },
        ));
  }
}