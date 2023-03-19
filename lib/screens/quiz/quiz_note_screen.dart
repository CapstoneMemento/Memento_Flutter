import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/quiz/quiz_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';

class QuizNoteScreen extends StatelessWidget {
  const QuizNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const answerForTest =
        "본 사건에서 A씨가 제기한 집합소유권 부인 청구권은 적부되어야 한다. 본 사건에서 B씨가 주장하는 집합소유권의 존재는 인정되어야 한다. 이에 따라, A씨는 B씨와 동일한 권리를 가지며, 해당 부동산에 대한 집합소유권을 행사할 수 있다.";

    final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: CustomTheme.themeData.primaryColor,
    );

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
                                style:
                                    CustomTheme.themeData.textTheme.bodyMedium,
                                children: const [
                              TextSpan(text: "발명의 완성이란 "),
                              WidgetSpan(
                                  child: SizedBox(
                                width: 50,
                                child: TextField(),
                              )),
                              TextSpan(text: " 이다."),
                            ]))
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
