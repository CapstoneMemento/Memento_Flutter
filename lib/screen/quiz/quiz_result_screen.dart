import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';

class QuizResultScreen extends StatelessWidget {
  final List answerList;

  QuizResultScreen({required this.answerList});

  final Widget logoHappy = SvgPicture.asset('assets/images/logo_happy.svg',
      semanticsLabel: '기뻐하는 메멘토 캐릭터 로고');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => NavigationBarWidget(
                            selectedIndex: 2,
                          )),
                  (route) => false);
            },
            child: const Text("확인"))
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            logoHappy,
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  "결과를 확인해보세요. 몇 개의 단어를 획득했나요?",
                  textAlign: TextAlign.center,
                )),
            const SizedBox(
              height: 20,
            ),
            ...answerList
                .map((answer) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              answer["title"],
                              style: CustomTheme.themeData.textTheme.titleSmall,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: answer["keywords"]
                                .map<Widget>((keyword) => Container(
                                      decoration: BoxDecoration(
                                          color: keyword["isAnswer"]
                                              ? const Color(0xFFA6DAFB)
                                              : const Color(0xFFD9D9D9),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 7),
                                        child: Text(keyword["text"]),
                                      ),
                                    ))
                                .toList(),
                          )
                        ],
                      ),
                    ))
                .toList()
          ],
        ),
      ),
    );
  }
}
