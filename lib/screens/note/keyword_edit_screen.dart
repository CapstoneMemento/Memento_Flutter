import 'package:flutter/material.dart';
import 'package:memento_flutter/api/keyword_api.dart';
import 'package:memento_flutter/screens/note/note_screen.dart';
import 'package:memento_flutter/widgets/app_bar/main_app_bar.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';
import 'package:memento_flutter/widgets/keyword_select.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';

class KeywordEditScreen extends StatefulWidget {
  final int noteId;
  List selectedIndex;
  final String content;

  KeywordEditScreen(
      {required this.noteId,
      required this.selectedIndex,
      required this.content});

  @override
  State<KeywordEditScreen> createState() => _KeywordEditScreenState();
}

class _KeywordEditScreenState extends State<KeywordEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppBar(leading: const BackIconButton(), actions: [
          TextButton(
              onPressed: () async {
                // 키워드 수정
                await KeywordAPI.editKeyword(indexList: widget.selectedIndex);

                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => NavigationBarWidget(
                                selectedIndex: 0,
                              )),
                      (route) => false);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => NoteScreen(
                              noteId: widget.noteId,
                            )),
                  );
                }
              },
              child: const Text("저장"))
        ]),
        body: KeywordSelect(
          content: widget.content,
          noteId: widget.noteId,
          selectedIndex: widget.selectedIndex,
        ));
  }
}
