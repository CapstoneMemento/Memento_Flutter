import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/quiz/quiz_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';

class QuizNoteScreen extends StatelessWidget {
  const QuizNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle ElevatedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: CustomTheme.themeData.primaryColor,
    );

    return Scaffold(
      appBar: BaseAppBar(
        title: const Text("퀴즈 풀기"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => QuizScreen()));
          },
        ),
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
              style: ElevatedButtonStyle,
              child: const Text("제출"),
            ),
          )
        ],
      ),
    );
  }
}
