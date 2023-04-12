import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/keyword_select_screen.dart';
import 'package:memento_flutter/screens/note_edit_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/close_icon_button.dart';

class OCRResultScreen extends StatefulWidget {
  final File imageFile; // 스캔한 이미지
  String extractedText; // 추출한 텍스트

  OCRResultScreen({required this.imageFile, required this.extractedText});

  @override
  State<OCRResultScreen> createState() => _OCRResultScreenState();
}

class _OCRResultScreenState extends State<OCRResultScreen> {
  /* Dialog에 표시할 아이템 */
  final List<Map<String, dynamic>> dialogItems = [
    {"id": "sentence", "title": "통문장"},
    {
      "id": "keyword",
      "title": "키워드",
    },
    {
      "id": "acronyms",
      "title": "두문자",
    }
  ];

  void goEditText() async {
    // 텍스트 편집 화면에서 수정한 노트 받아오기
    final editedText = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              NoteEditScreen(extractedText: widget.extractedText),
        ));

    // 시용자가 텍스트를 수정했으면 갱신
    if (editedText != null) {
      setState(() {
        widget.extractedText = editedText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: BaseAppBar(
        title: Text(
          "텍스트 추출 결과",
          style: CustomTheme.themeData.textTheme.titleMedium,
        ),
        actions: [CloseIconButton()],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: deviceWidth,
              decoration: const BoxDecoration(color: Colors.black),
              child: ExtendedImage.file(
                widget.imageFile,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: goEditText,
                child: Text(widget.extractedText),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomTheme.themeData.primaryColor,
        child: const Text("다음"),
        onPressed: () async {
          // 노트 저장하고 id 받아오기
          const noteId = "123";

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => KeywordSelectScreen(
                        noteId: noteId,
                        extractedText: widget.extractedText,
                      )));
        },
      ),
    );
  }
}
