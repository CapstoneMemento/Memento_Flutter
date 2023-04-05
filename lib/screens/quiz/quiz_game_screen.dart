import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';

class QuizGameScreen extends StatefulWidget {
  const QuizGameScreen({super.key});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  final Widget logoDown = SvgPicture.asset('assets/images/logo_down.svg',
      semanticsLabel: '판례 제목을 쳐다보고 있는 메멘토 캐릭터 로고');

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = '판례제목'; // Set the initial value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          NavigationBarWidget(selectedIndex: 2)),
                  (route) => false);
            },
            child: const Text("나가기"))
      ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(children: [
                  logoDown,
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: CustomTheme.themeData.primaryColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0))),
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: _controller,
                        readOnly: true,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        style: CustomTheme.themeData.textTheme.bodyMedium,
                      ),
                    ),
                  )
                ]),
              ),
              const Keyword(
                content: "특허제품",
              )
            ],
          ),
          Column(
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
          ),
          Column(
            children: [
              const Keyword(
                content: "특허권침해",
                boxColor: Color(0xFFA6DAFB),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: CustomTheme.themeData.primaryColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0))),
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(border: InputBorder.none),
                    style: CustomTheme.themeData.textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Keyword extends StatelessWidget {
  final String content;
  final Color? boxColor;

  const Keyword(
      {required this.content, this.boxColor = const Color(0xFFD9D9D9)});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: boxColor,
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Text(content),
      ),
    );
  }
}
