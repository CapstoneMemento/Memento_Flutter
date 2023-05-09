import 'package:flutter/material.dart';
import 'package:memento_flutter/api/keyword_api.dart';
import 'package:memento_flutter/themes/custom_theme.dart';

class KeywordSelect extends StatefulWidget {
  List selectedIndex;
  final int noteId;
  final String content;

  KeywordSelect({
    required this.selectedIndex,
    required this.noteId,
    required this.content,
  });

  @override
  State<KeywordSelect> createState() => _KeywordSelectState();
}

class _KeywordSelectState extends State<KeywordSelect> {
  int prevStartIndex = -1;
  // 선택한 문자 TextStyle
  final highlightStyle =
      TextStyle(backgroundColor: Colors.yellow.withOpacity(0.5));

  /* 사용자가 키워드를 선택하면 index 저장 */
  void _onSelectionChanged(selection, cause) {
    final startIndex = selection.baseOffset;
    final endIndex = selection.extentOffset;

    if (cause == SelectionChangedCause.longPress ||
        cause == SelectionChangedCause.drag) {
      saveIndex(newStartIndex: startIndex, newEndIndex: endIndex, cause: cause);
      // 오름차순 정렬 (사용자가 순서대로 밑줄을 긋지 않을 경우에 대비)
      sortIndex(indexList: widget.selectedIndex);
    }

    // 드래그 중 화면 새로고침 횟수 줄이기
    if (prevStartIndex != startIndex || cause == SelectionChangedCause.tap) {
      setState(() {});
    }
    prevStartIndex = startIndex;
  }

  void saveIndex(
      {required int newStartIndex,
      required int newEndIndex,
      required SelectionChangedCause cause}) {
    var isSaveNew = true; // 인덱스 새로 저장
    final isReverse = newStartIndex >= newEndIndex;

    // 반대로 밑줄 그으면 종료
    if (isReverse) {
      return;
    }

    for (var i = 0; i < widget.selectedIndex.length; i++) {
      final start = widget.selectedIndex[i]["first"]; // 시작 인덱스
      final end = widget.selectedIndex[i]["last"]; // 끝 인덱스
      final pressAgain = (cause == SelectionChangedCause.longPress) &&
          newStartIndex >= start &&
          newEndIndex <= end;
      final isDragging = newStartIndex == start;
      final include = newStartIndex < start && newEndIndex > start;

      // 기존 밑줄을 다시 길게 누르면 삭제
      if (pressAgain) {
        widget.selectedIndex.removeAt(i);
        // 새로 인덱스 저장 X
        isSaveNew = false;
        break;
      }

      // 사용자가 밑줄 긋는 중이면
      if (isDragging) {
        // 기존 끝 인덱스 갱신
        widget.selectedIndex[i]["last"] = newEndIndex;
        isSaveNew = false;
      }

      // 기존 밑줄을 포함하면 삭제
      if (include) {
        widget.selectedIndex.removeAt(i);
        isSaveNew = false;
      }
    }

    /* 새 인덱스 저장 */
    if (isSaveNew) {
      widget.selectedIndex.add({
        "first": newStartIndex,
        "last": newEndIndex,
        "noteid": widget.noteId
      });
    }
  }

  /* 오름차순 정렬 */
  void sortIndex({required List indexList}) {
    indexList.sort((a, b) {
      if (a["first"] == b["first"]) {
        return a["last"].compareTo(b["last"]);
      }
      return a["first"].compareTo(b["first"]);
    });
  }

  List<InlineSpan> getSpanList() {
    final selectedText = KeywordAPI.sliceText(
        content: widget.content, selectedIndex: widget.selectedIndex);

    final result = selectedText
        .map((e) => TextSpan(
            text: e["text"],
            style: e["isKeyword"] ? highlightStyle : const TextStyle()))
        .toList();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
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
              selectionColor: Colors.grey.withOpacity(0.5),
            ),
            child: SelectableText.rich(
              TextSpan(children: getSpanList()),
              toolbarOptions: const ToolbarOptions(selectAll: false),
              onSelectionChanged: _onSelectionChanged,
            ),
          ),
        ]),
      ),
    );
  }
}
