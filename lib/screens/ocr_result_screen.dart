import 'package:firebase_storage/firebase_storage.dart';
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
  final List<Map<String, dynamic>> dialogItems = [
    {
      "id": "1",
      "title": "통문장",
      "onPressed": (context) {
        // 문장 그대로 저장
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home()));
      }
    },
    {
      "id": "2",
      "title": "키워드",
      "onPressed": (context) {
        // 키워드 선택 화면으로 이동
      }
    },
    {
      "id": "3",
      "title": "두문자",
      "onPressed": (context) {
        // 두문자 선택 화면으로 이동
      }
    }
  ];

  /* Firebase storage 초기화 */
  final storageRef = FirebaseStorage.instance.ref();
  late final scannedImageRef = storageRef.child("scannedImage.jpg");

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
                // 이전 버튼을 누르면 editedText가 존재하지 않는다.
                if (editedText) {
                  setState(() {
                    widget.extractedText = editedText;
                  });
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomTheme.themeData.primaryColor,
        child: const Icon(Icons.check),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text("암기 방식 선택"),
                    content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: dialogItems
                            .map((e) => OutlinedButton(
                                  child: Text(e["title"]),
                                  onPressed: () {
                                    // 문장 그대로 저장
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Home()));
                                  },
                                ))
                            .toList()));
              });
        },
      ),
    );
  }
}
