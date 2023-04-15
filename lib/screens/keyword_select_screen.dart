import 'package:flutter/material.dart';
import 'package:memento_flutter/api/keyword_api.dart';
import 'package:memento_flutter/api/note_api.dart';
import 'package:memento_flutter/screens/title_setting_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/main_app_bar.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';

class KeywordSelectScreen extends StatefulWidget {
  final int noteId;
  final String extractedText;

  const KeywordSelectScreen(
      {required this.noteId, required this.extractedText});

  @override
  State<KeywordSelectScreen> createState() => _KeywordSelectScreenState();
}

class _KeywordSelectScreenState extends State<KeywordSelectScreen> {
  int prevStartIndex = -1; // 이전 키워드 시작 인덱스
  // 선택한 문자의 인덱스 {start, end, noteId}
  List<Map<String, dynamic>> selectedIndex = [];
  // 선택한 문자 {text, isKeyword}
  List<Map<String, dynamic>> selectedText = [];
  // 선택한 문자 TextStyle
  final highlightStyle =
      TextStyle(backgroundColor: Colors.yellow.withOpacity(0.5));

  List<InlineSpan> getSpanList() {
    sliceText(widget.extractedText, selectedIndex);

    final result = selectedText
        .map((e) => TextSpan(
            text: e["text"],
            style: e["isKeyword"] ? highlightStyle : const TextStyle()))
        .toList();

    return result;
  }

  /* 선택한 문자와 그러지 않은 문자를 나눠서 selectedText에 저장 */
  void sliceText(String totalText, List<Map<String, dynamic>> selectedIndex) {
    List<Map<String, dynamic>> result = []; // 선택한 문자 {text, isKeyword}
    int prevEndIndex = 0; // 이전 end index

    for (final index in selectedIndex) {
      final start = index["first"];
      final end = index["last"];

      result.add({
        "text": totalText.substring(prevEndIndex, start),
        "isKeyword": false
      });
      result.add({"text": totalText.substring(start, end), "isKeyword": true});
      prevEndIndex = end; // 이전 end index 저장
    }
    // 마지막 문자 저장
    result.add({"text": totalText.substring(prevEndIndex), "isKeyword": false});

    selectedText = result;
  }

  /* 사용자가 키워드를 선택하면 index 저장 */
  void _onSelectionChanged(selection, cause) {
    final startIndex = selection.baseOffset;
    final endIndex = selection.extentOffset;

    // 드래그 중 화면 새로고침 횟수 줄이기
    if (prevStartIndex != startIndex) {
      setState(() {});
    }
    prevStartIndex = startIndex;

    if (cause == SelectionChangedCause.longPress ||
        cause == SelectionChangedCause.drag) {
      saveIndex(startIndex, endIndex);
      // 오름차순 정렬 (사용자가 순서대로 밑줄을 긋지 않을 경우에 대비)
      sortIndex(selectedIndex);
    }
  }

  void saveIndex(int newStartIndex, int newEndIndex) {
    var isSaveNew = true; // 인덱스 새로 저장
    final isReverse = newStartIndex >= newEndIndex;

    // 반대로 밑줄 그으면 종료
    if (isReverse) {
      return;
    }

    for (var i = 0; i < selectedIndex.length; i++) {
      final start = selectedIndex[i]["first"]; // 시작 인덱스
      final end = selectedIndex[i]["last"]; // 끝 인덱스
      final pressAgain = newStartIndex >= start && newEndIndex <= end;
      final isDragging = newStartIndex == start;
      final include = newStartIndex < start && newEndIndex > start;

      // 기존 밑줄을 다시 길게 누르면 삭제
      if (pressAgain) {
        selectedIndex.removeAt(i);
        // 새로 인덱스 저장 X
        isSaveNew = false;
        break;
      }

      // 사용자가 밑줄 긋는 중이면
      if (isDragging) {
        // 기존 끝 인덱스 갱신
        selectedIndex[i]["last"] = newEndIndex;
        isSaveNew = false;
      }

      // 기존 밑줄을 포함하면 삭제
      if (include) {
        selectedIndex.removeAt(i);
        isSaveNew = false;
      }
    }

    /* 새 인덱스 저장 */
    if (isSaveNew) {
      selectedIndex.add({
        "first": newStartIndex,
        "last": newEndIndex,
        "noteid": widget.noteId
      });
    }
  }

  /* 오름차순 정렬 */
  void sortIndex(List<Map<String, dynamic>> index) {
    selectedIndex.sort((a, b) {
      if (a["first"] == b["first"]) {
        return a["last"].compareTo(b["last"]);
      }
      return a["first"].compareTo(b["first"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        leading: const BackIconButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.black,
            onPressed: () async {
              // 미리 저장한 노트 삭제
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            "키워드를 선택하세요.",
            style: CustomTheme.themeData.textTheme.titleSmall,
          ),
          const SizedBox(
            height: 16,
          ),
          TextSelectionTheme(
            data: TextSelectionThemeData(
              selectionColor: Colors.yellow.withOpacity(0.5),
            ),
            child: SelectableText.rich(
              TextSpan(children: getSpanList()),
              toolbarOptions: const ToolbarOptions(selectAll: false),
              onSelectionChanged: _onSelectionChanged,
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomTheme.themeData.primaryColor,
        child: const Text("다음"),
        onPressed: () async {
          // selectedIndex 키워드 DB에 저장
          await KeywordAPI.saveKeyword(selectedIndex);

          if (mounted) {
            // 판례 제목 지정으로 이동
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TitleSettingScreen(
                    noteId: widget.noteId,
                    selectedText: selectedText,
                    content: widget.extractedText)));
          }
        },
      ),
    );
  }
}
