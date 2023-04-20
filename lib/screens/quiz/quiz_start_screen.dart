import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memento_flutter/screens/quiz/quiz_game_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';

class QuizStartScreen extends StatelessWidget {
  QuizStartScreen();

  final Widget logoBasic = SvgPicture.asset('assets/images/logo_basic.svg',
      width: 100, semanticsLabel: '메멘토 캐릭터 로고');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const QuizGameScreen()));
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logoBasic,
            const SizedBox(
              height: 20,
            ),
            Text(
              "저랑 암기 상태를 확인해봐요",
              style: CustomTheme.themeData.textTheme.titleSmall,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "메멘토를 상대로 퀴즈가 진행됩니다.",
              style: CustomTheme.themeData.textTheme.bodySmall,
            ),
            Text(
              "판례 제목이 주어지면, 관련 키워드를",
              style: CustomTheme.themeData.textTheme.bodySmall,
            ),
            Text(
              "문장 순서대로 입력하세요.",
              style: CustomTheme.themeData.textTheme.bodySmall,
            ),
            const SizedBox(
              height: 100,
            ),
            Text(
              "터치하여 시작",
              style: TextStyle(color: CustomTheme.themeData.primaryColor),
            )
          ],
        ),
      ),
    );
  }
}
