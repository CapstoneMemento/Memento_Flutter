import 'package:flutter/material.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';

class QuizNoteScreen extends StatelessWidget {
  const QuizNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const content =
        "특허권침해소송의 상대방이 제조 등을 하는 제품 또는 사용하는 방법(이하 ‘침해제품 등’이라고 한다)이 특허발명의 특허권을 침해한다고 하기 위해서는 특허발명의 특허청구범위에 기재된 각 구성요소와 그 구성요소 간의 유기적 결합관계가 침해제품 등에 그대로 포함되어 있어야 한다. 침해제품 등에 특허발명의 특허청구범위에 기재된 구성 중 변경된 부분이 있는 경우에도, 특허발명과 과제 해결원리가 동일하고, 특허발명에서와 실질적으로 동일한 작용효과를 나타내며, 그와 같이 변경하는 것이 그 발명이 속하는 기술분야에서 통상의 지식을 가진 사람이라면 누구나 쉽게 생각해 낼 수 있는 정도라면, 특별한 사정이 없는 한 침해제품 등은 특허발명의 특허청구범위에 기재된 구성과 균등한 것으로서 여전히 특허발명의 특허권을 침해한다고 보아야 한다.";
    // 띄어쓰기도 한 단어로 분리해야 함
    const keywords = [
      "특허권침해소송",
      "침해제품",
      "특허발명",
      "특허청구범위",
      "구성요소",
      "유기적",
      "결합관계",
      "변경된",
      "부분",
      "과제",
      "해결원리",
      "작용효과",
      "기술분야",
      "통상의",
      "지식",
      "균등한",
      "것",
      "특허권",
      "침해"
    ];

    final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: CustomTheme.themeData.primaryColor,
    );

    /* 키워드 인덱스에 따라, 전체 문장을 나눠서 배열에 저장 */
    List<dynamic> findKeyword(content, keywords) {
      var result = []; // {text, isKeyword}
      var remainSentence = content;

      for (String keyword in keywords) {
        final startIndex = remainSentence.indexOf(keyword); // 키워드 start index
        final endIndex = startIndex + keyword.length; // 키워드 end index
        final prevSentence =
            remainSentence.substring(0, startIndex); // 키워드 전의 문장
        final keySentence =
            remainSentence.substring(startIndex, endIndex); // content의 키워드 부분

        result.add({"text": prevSentence, "isKeyword": false});
        result.add({"text": keySentence, "isKeyword": true});
        remainSentence = remainSentence.substring(endIndex);
      }

      return result;
    }

    List<InlineSpan> getSpan() {
      final data = findKeyword(content, keywords);
      final spans = data
          .map((e) => {
                e["isKeyword"]
                    ? WidgetSpan(
                        child: SizedBox(
                        width: 10.0 * e["text"].length,
                        child: TextField(
                          style: CustomTheme.themeData.textTheme.bodyMedium,
                        ),
                      ))
                    : TextSpan(text: e["text"])
              })
          .toList();

      // List<Set<InlineSpan>> 에서 Set 제거
      final flattenedSpans = spans.expand((e) => e).toList();

      return flattenedSpans;
    }

    return Scaffold(
      appBar: const BaseAppBar(
        title: Text("퀴즈 풀기"),
        leading: BackIconButton(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "판례 제목",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "발명의 완성",
                    style: CustomTheme.themeData.textTheme.titleSmall,
                  )
                ],
              )),
          Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: CustomTheme.themeData.primaryColor, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("키워드를 입력하세요",
                            style: CustomTheme.themeData.textTheme.titleSmall),
                        RichText(
                            text: TextSpan(
                          style: CustomTheme.themeData.textTheme.bodyMedium,
                          children: getSpan(),
                        ))
                      ],
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                // 제출
              },
              style: elevatedButtonStyle,
              child: const Text("제출"),
            ),
          )
        ],
      ),
    );
  }
}
