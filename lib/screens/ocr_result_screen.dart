import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/home.dart';
import 'package:memento_flutter/screens/note_edit_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';

class OCRResultScreen extends StatefulWidget {
  final String imageURL; // 스캔한 이미지
  String extractedText; // 추출한 텍스트

  OCRResultScreen({required this.imageURL, required this.extractedText});

  @override
  State<OCRResultScreen> createState() => _OCRResultScreenState();
}

class _OCRResultScreenState extends State<OCRResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: Text(
          "텍스트 추출 결과",
          style: CustomTheme.themeData.textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.imageURL),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              child: Text(widget.extractedText),
              onTap: () async {
                // 텍스트 편집 화면에서 수정한 노트 받아오기
                final editedText = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NoteEditScreen(extractedText: widget.extractedText),
                    ));
                setState(() {
                  widget.extractedText = editedText;
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomTheme.themeData.primaryColor,
        child: const Icon(Icons.check),
        onPressed: () {
          // DB에 노트 저장
          // Home 화면으로 이동
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Home()));
        },
      ),
    );
  }
}
