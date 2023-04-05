import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/quiz/sentence_quiz_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/main_app_bar.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';

class KeywordQuizScreen extends StatefulWidget {
  const KeywordQuizScreen();

  @override
  State<KeywordQuizScreen> createState() => _KeywordQuizScreenState();
}

class _KeywordQuizScreenState extends State<KeywordQuizScreen> {
  var isSubmitted = false;

  final title = "발명의 완성";
  final content =
      "특허권침해소송의 상대방이 제조 등을 하는 제품 또는 사용하는 방법(이하 ‘침해제품 등’이라고 한다)이 특허발명의 특허권을 침해한다고 하기 위해서는 특허발명의 특허청구범위에 기재된 각 구성요소와 그 구성요소 간의 유기적 결합관계가 침해제품 등에 그대로 포함되어 있어야 한다. 침해제품 등에 특허발명의 특허청구범위에 기재된 구성 중 변경된 부분이 있는 경우에도, 특허발명과 과제 해결원리가 동일하고, 특허발명에서와 실질적으로 동일한 작용효과를 나타내며, 그와 같이 변경하는 것이 그 발명이 속하는 기술분야에서 통상의 지식을 가진 사람이라면 누구나 쉽게 생각해 낼 수 있는 정도라면, 특별한 사정이 없는 한 침해제품 등은 특허발명의 특허청구범위에 기재된 구성과 균등한 것으로서 여전히 특허발명의 특허권을 침해한다고 보아야 한다.";
  final selectedIndex = [
    {"start": 0, "end": 7, "noteId": "123"},
    {"start": 18, "end": 22, "noteId": "123"},
    {"start": 55, "end": 59, "noteId": "123"},
    {"start": 70, "end": 76, "noteId": "123"},
    {"start": 84, "end": 88, "noteId": "123"},
    {"start": 95, "end": 98, "noteId": "123"},
  ];

  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: CustomTheme.themeData.primaryColor,
  );

  @override
  Widget build(BuildContext context) {
    /* 문자 배열로 키워드가 주어질 경우 */
    List<dynamic> findKeywords(content, keywords) {
      var result = []; // {text, isKeyword}
      var remainSentence = content;

      for (String keyword in keywords) {
        final startIndex = remainSentence.indexOf(keyword); // 키워드 start index
        final endIndex = startIndex + keyword.length; // 키워드 end index
        final prevSentence =
            remainSentence.substring(0, startIndex); // 키워드 전의 문장
        final keySentence =
            remainSentence.substring(startIndex, endIndex); // content의 키워드 부분

        // 빈 문자는 제외
        if (prevSentence != "") {
          result.add({"text": prevSentence, "isKeyword": false});
        }
        result.add({"text": keySentence, "isKeyword": true});
        remainSentence = remainSentence.substring(endIndex);
      }

      // 남은 문장 저장
      result.add({"text": remainSentence, "isKeyword": false});

      return result;
    }

    /* 키워드 인덱스에 따라, 전체 문장을 나눠서 배열에 저장 */
    List<dynamic> sliceText(content, selectedIndex) {
      var result = []; // {startIndex, text, isKeyword}
      var prevEndIndex = 0; // 이전 end index

      for (final index in selectedIndex) {
        final startIndex = index["start"];
        final endIndex = index["end"];

        result.add({
          "text": content.substring(prevEndIndex, startIndex),
          "isKeyword": false
        });
        result.add({
          "text": content.substring(startIndex, endIndex),
          "isKeyword": true
        });
        prevEndIndex = endIndex; // 이전 end index 저장
      }

      // 마지막 문자 저장
      result.add({"text": content.substring(prevEndIndex), "isKeyword": false});

      return result;
    }

    List<InlineSpan> getSpanList() {
      List<InlineSpan> spanList = [];
      final result = sliceText(content, selectedIndex);

      for (final element in result) {
        if (element["isKeyword"]) {
          spanList.add(WidgetSpan(
              child: SizedBox(
            width: 18.0 * element["text"].length,
            height: 26,
            child: TextField(
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: CustomTheme.themeData.primaryColor,
              ),
            ),
          )));
        } else {
          spanList.add(TextSpan(text: element["text"]));
        }
      }

      return spanList;
    }

    List<InlineSpan> getAnswer() {
      List<InlineSpan> spanList = [];
      final result = sliceText(content, selectedIndex);

      for (final element in result) {
        if (element["isKeyword"]) {
          spanList.add(TextSpan(
            text: element["text"],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.red,
            ),
          ));
        } else {
          spanList.add(TextSpan(text: element["text"]));
        }
      }

      return spanList;
    }

    return Scaffold(
      appBar: const MainAppBar(
        title: Text("퀴즈 풀기"),
        leading: BackIconButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            const Text(
              "판례 제목",
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: CustomTheme.themeData.textTheme.titleSmall,
            ),
            const SizedBox(
              height: 26,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(
                    style: CustomTheme.themeData.textTheme.bodyMedium,
                    children: getSpanList(),
                  )),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            ////////////// 정답 확인 //////////////
            if (isSubmitted)
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                        style: CustomTheme.themeData.textTheme.bodyMedium,
                        children: getAnswer(),
                      )),
                    ],
                  )),
            if (isSubmitted)
              const SizedBox(
                height: 20,
              ),
            //////////////

            ElevatedButton(
              onPressed: () {
                if (isSubmitted) {
                  // 다 풀었으면 문장 쓰기로 이동
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SentenceQuizScreen()));
                } else {
                  // 채점 결과 보여주기
                  setState(() {
                    isSubmitted = true;
                  });
                }
              },
              style: elevatedButtonStyle,
              child: Text(isSubmitted ? "다음" : "제출"),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
