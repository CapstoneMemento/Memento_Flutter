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

    if (selectedIndex.isNotEmpty) {
      /* 선택한 text이면 true, 아니면 false를 String과 함께 저장 */
      for (List<int> index in selectedIndex) {
        final start = index[0];
        final end = index[1];

        result.add([totalText.substring(prevEndIndex, start), false]);
        result.add([totalText.substring(start, end), true]);
        prevEndIndex = end; // 이전 end index 저장
      }
    }
    // 마지막 문자 저장
    result.add([totalText.substring(prevEndIndex), false]);

    return result;
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
              onSelectionChanged: ((selection, cause) {
                print(selection);
                print(cause);
                /* 사용자가 키워드를 선택하면 index 저장 */
                if (cause == SelectionChangedCause.longPress) {
                  /* 시작 인덱스가 동일한 기존 아이템이 있으면, 최근 거로 대체 */
                  var flag = false;

                  for (int i = 0; i < selectedIndex.length; i++) {
                    final start = selectedIndex[i][0]; // 시작 인덱스

                    if (start == selection.baseOffset) {
                      setState(() {
                        selectedIndex[i][1] = selection.extentOffset;
                      });

                      flag = true;
                      break;
                    }
                  }

                  /* 시작 인덱스가 동일한 아이템이 없으면 새로 추가 */
                  if (!flag) {
                    setState(() {
                      selectedIndex
                          .add([selection.baseOffset, selection.extentOffset]);
                    });
                  }
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
