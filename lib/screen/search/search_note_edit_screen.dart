import 'package:flutter/material.dart';
import 'package:memento_flutter/api/note_api.dart';
import 'package:memento_flutter/screen/keyword_select_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/utility/keyword.dart';
import 'package:memento_flutter/widgets/app_bar/main_app_bar.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';
import 'package:memento_flutter/widgets/loading.dart';

class SearchNoteEditScreen extends StatefulWidget {
  final String content;

  const SearchNoteEditScreen({required this.content});

  @override
  State<SearchNoteEditScreen> createState() => _SearchNoteEditScreenState();
}

class _SearchNoteEditScreenState extends State<SearchNoteEditScreen> {
  TextEditingController contentController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    //  TextField 초기값 설정
    setState(() {
      contentController.text = widget.content;
    });
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        leading: const BackIconButton(),
        actions: [
          TextButton(
            child: const Text("저장"),
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              final editedContent = contentController.text;
              // 노트 저장하고 노트 아이디 받아오기
              final noteId = await NoteAPI.addNote(content: editedContent);
              // 추천 키워드 받아오기
              final result = await Keyword.getKeywordIndexFromNote(
                  content: editedContent, noteId: noteId);
              // 키워드 선택 화면으로 이동
              if (mounted) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => KeywordSelectScreen(
                        noteId: int.parse(result["noteId"]),
                        content: editedContent,
                        selectedIndex: result["indexList"])));
              }
              setState(() {
                isLoading = false;
              });
            },
          )
        ],
      ),
      body: isLoading
          ? Loading()
          : SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    maxLines: (widget.content.length / 30).ceil(),
                    style: CustomTheme.themeData.textTheme.bodyMedium,
                    controller: contentController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "판례를 입력하세요",
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                  )),
            ),
    );
  }
}
