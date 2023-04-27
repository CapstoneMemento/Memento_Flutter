import 'package:flutter/material.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/main_app_bar.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';

class SentenceQuizScreen extends StatelessWidget {
  const SentenceQuizScreen();

  @override
  Widget build(BuildContext context) {
    const title = "발명의 완성";

    final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: CustomTheme.themeData.primaryColor,
    );

    return Scaffold(
        appBar: MainAppBar(
          title: const Text("퀴즈 풀기"),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => NavigationBarWidget(
                              selectedIndex: 2,
                            )),
                    (route) => false);
              },
              color: Colors.black,
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
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
                child: TextField(
                  style: CustomTheme.themeData.textTheme.bodyMedium,
                  maxLines: 15,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(
                            color: CustomTheme.themeData.primaryColor),
                      ),
                      hintText: "제목을 보고 판례를 적어보세요.",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      )),
                )),
            const SizedBox(
              height: 26,
            ),
            ElevatedButton(
              onPressed: () {
                // 맞은 개수 표시
                // 다시 풀기 물어보기
              },
              style: elevatedButtonStyle,
              child: const Text("제출"),
            ),
            const SizedBox(
              height: 30,
            ),
          ]),
        ));
  }
}
