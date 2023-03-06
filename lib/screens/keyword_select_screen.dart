import 'package:flutter/material.dart';

import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';

class KeywordSelectScreen extends StatefulWidget {
  final String extractedText;

  const KeywordSelectScreen({required this.extractedText});

  @override
  State<KeywordSelectScreen> createState() => _KeywordSelectScreenState();
}

class _KeywordSelectScreenState extends State<KeywordSelectScreen> {
  // 선택한 문자의 인덱스 [start, end]
  final List<List<int>> selectedIndex = [];
  // 선택한 문자 text style
  final highlightStyle =
      TextStyle(backgroundColor: Colors.yellow.withOpacity(0.5));

  /* 선택한 문자와 그러지 않은 문자를 나눠서 배열에 저장 */
  List<List<dynamic>> sliceText(
      String totalText, List<List<int>> selectedIndex) {
    final List<List<dynamic>> result = []; // [String text, bool highlighted]

    int prevEndIndex = 0; // 이전 end index
    /* 선택한 text이면 true, 아니면 false를 String과 함께 저장 */
    for (List<int> index in selectedIndex) {
      final start = index[0];
      final end = index[1];

      result.add([totalText.substring(prevEndIndex, start), false]);
      result.add([totalText.substring(start, end), true]);
      prevEndIndex = end; // 이전 end index 저장
    }
    // 마지막 문자 저장
    result.add([totalText.substring(prevEndIndex), false]);

    return result;
  }

  void saveIndex(int newStartIndex, int newEndIndex) {
    /* 시작 인덱스가 동일하고
      끝 인덱스가 기존 끝 인덱스보다 크면,
      최근 거로 대체 (드래그에서 여러 단어를 밑줄 그을 경우) */
    var flag = false;

    for (int i = 0; i < selectedIndex.length; i++) {
      final start = selectedIndex[i][0]; // 시작 인덱스
      final end = selectedIndex[i][1]; // 끝 인덱스

      if (start == newStartIndex && end < newEndIndex) {
        selectedIndex[i][1] = newEndIndex;
        flag = true;
        break;
      }
    }

    /* 시작 인덱스가 동일한 아이템이 없으면 새로 추가
      (한 단어만 밑줄 칠 경우) */
    if (!flag) {
      selectedIndex.add([newStartIndex, newEndIndex]);
    }
  }

  /* 오름차순 정렬 */
  void sortIndex(List<List<int>> index) {
    selectedIndex.sort(((a, b) {
      if (a[0] == b[0]) {
        return a[1].compareTo(b[1]);
      }
      return a[0].compareTo(b[0]);
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
                          text: e[0],
                          style: e[1] ? highlightStyle : const TextStyle()))
                      .toList()),
              toolbarOptions: const ToolbarOptions(selectAll: false),
              onSelectionChanged: ((selection, cause) {
                /* 사용자가 키워드를 선택하면 index 저장 */
                if (cause == SelectionChangedCause.longPress) {
                  saveIndex(selection.baseOffset, selection.extentOffset);
                  // 오름차순 정렬
                  sortIndex(selectedIndex);
                  setState(() {});
                }
              }),
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 판례 제목 지정으로 이동
        },
        backgroundColor: CustomTheme.themeData.primaryColor,
        child: const Icon(Icons.check),
      ),
    );
  }
}
