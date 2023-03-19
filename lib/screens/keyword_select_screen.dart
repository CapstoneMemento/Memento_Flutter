import 'package:flutter/material.dart';

import 'package:memento_flutter/screens/title_setting_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';

class KeywordSelectScreen extends StatefulWidget {
  final String noteId;
  final String extractedText;

  const KeywordSelectScreen(
      {required this.noteId, required this.extractedText});

  @override
  State<KeywordSelectScreen> createState() => _KeywordSelectScreenState();
}

class _KeywordSelectScreenState extends State<KeywordSelectScreen> {
  // 선택한 문자의 인덱스 {start, end, noteId}
  List<Map<String, dynamic>> selectedIndex = [];
  // 선택한 문자 {text, isKeyword}
  List<Map<String, dynamic>> selectedText = [];
  // 선택한 문자 text style
  final highlightStyle =
      TextStyle(backgroundColor: Colors.yellow.withOpacity(0.5));

  /* 선택한 문자와 그러지 않은 문자를 나눠서 배열에 저장 */
  List<Map<String, dynamic>> sliceText(
      String totalText, List<Map<String, dynamic>> selectedIndex) {
    List<Map<String, dynamic>> result = []; // [String text, bool highlighted]

    int prevEndIndex = 0; // 이전 end index
    /* 선택한 text이면 true, 아니면 false를 String과 함께 저장 */
    for (final index in selectedIndex) {
      final start = index["start"];
      final end = index["end"];

      result.add({
        "text": totalText.substring(prevEndIndex, start),
        "isKeyword": false
      });
      result.add({"text": totalText.substring(start, end), "isKeyword": true});
      prevEndIndex = end; // 이전 end index 저장
    }
    // 마지막 문자 저장
    result.add({"text": totalText.substring(prevEndIndex), "isKeyword": false});
    selectedText = result; // 선택한 문자 저장

    return result;
  }

  void _onSelectionChanged(selection, cause) {
    /* 사용자가 키워드를 선택하면 index 저장 */
    if (cause == SelectionChangedCause.longPress ||
        cause == SelectionChangedCause.drag) {
      saveIndex(selection.baseOffset, selection.extentOffset);
      // 오름차순 정렬 (사용자가 )
      sortIndex(selectedIndex);
      setState(() {});
    }
  }

  void saveIndex(int newStartIndex, int newEndIndex) {
    /* 시작 인덱스가 동일하고
      끝 인덱스가 기존 끝 인덱스보다 크면,
      최근 거로 대체 (드래그해서 여러 단어를 밑줄 그을 경우) */
    var isSaveNew = true;

    for (var i = 0; i < selectedIndex.length; i++) {
      final start = selectedIndex[i]["start"]; // 시작 인덱스
      final end = selectedIndex[i]["end"]; // 끝 인덱스

      /* 인덱스 삭제 */
      // 기존 밑줄을 다시 길게 누르면
      if (newStartIndex >= start && newEndIndex <= end) {
        // 기존 인덱스 삭제
        selectedIndex.removeAt(i);
        // 새 인덱스 저장 X
        isSaveNew = false;
        break;
      }

      // 사용자가 밑줄 긋는 중이면
      if (start == newStartIndex && end < newEndIndex) {
        // 기존 끝 인덱스 갱신
        selectedIndex[i]["end"] = newEndIndex;
        // 새 인덱스 저장 X
        isSaveNew = false;
        break;
      }
    }

    /* 새 인덱스 저장 */
    if (isSaveNew) {
      selectedIndex.add({
        "start": newStartIndex,
        "end": newEndIndex,
        "noteId": widget.noteId
      });
    }
  }

  /* 오름차순 정렬 */
  void sortIndex(List<Map<String, dynamic>> index) {
    selectedIndex.sort(((a, b) {
      if (a["start"] == b["start"]) {
        return a["end"].compareTo(b["end"]);
      }
      return a["start"].compareTo(b["start"]);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        actions: [
          Icon(
            Icons.close,
            color: Colors.black,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "키워드를 선택하세요.",
            style: CustomTheme.themeData.textTheme.titleSmall,
          ),
          const SizedBox(
            height: 16,
          ),
          TextSelectionTheme(
            data: TextSelectionThemeData(
              selectionColor: Colors.yellow.withOpacity(0),
            ),
            child: SelectableText.rich(
              TextSpan(
                  children: sliceText(widget.extractedText, selectedIndex)
                      .map((e) => TextSpan(
                          text: e["text"],
                          style: e["isKeyword"]
                              ? highlightStyle
                              : const TextStyle()))
                      .toList()),
              toolbarOptions: const ToolbarOptions(selectAll: false),
              onSelectionChanged: _onSelectionChanged,
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 판례 제목 지정으로 이동
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TitleSettingScreen(selectedText: selectedText)));
        },
        backgroundColor: CustomTheme.themeData.primaryColor,
        child: const Text("다음"),
      ),
    );
  }
}
