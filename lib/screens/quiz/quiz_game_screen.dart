import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memento_flutter/api/quiz_api.dart';
import 'package:memento_flutter/screens/quiz/quiz_result_screen.dart';
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
  String mementoWord = "";
  String userWord = "";
  String answer = "";
  String title = "";
  Timer? _timer;
  QuizAPI quizAPI = QuizAPI();

  // DB에서 불러오기
  final questionList = [
    {
      "title": "모인대상발명",
      "keywords": [
        "모인대상발명",
        "통상의 기술자",
        "발명의 작용효과",
        "특별한 차이",
        "기술적 사상의 창작",
        "기여하지 않은 경우",
        "무권리자 출원"
      ]
    }
  ];

  final TextEditingController mementoController = TextEditingController();
  final TextEditingController userController = TextEditingController();

  var inputBorderStyle = Border.all(color: CustomTheme.themeData.primaryColor);

  @override
  void initState() {
    super.initState();
    quizAPI.fetchQuizList();
    mementoController.text = '. . .'; // Set the initial value
    answer = quizAPI.getKeyword(); // 첫 번째 정답
    title = quizAPI.getTitle(); // 첫 번째 제목
    _timer = setMementoTimer();
  }

  Timer setMementoTimer() {
    return Timer.periodic(const Duration(seconds: 30), (timer) {
      quizAPI.setAnswer(isAnswer: false); // 컴퓨터 정답 처리 (사용자 오답)
      mementoWord = answer; // 메멘토 키워드 획득
      getNextQuiz();
    });
  }

  void getNextQuiz() {
    answer = quizAPI.getKeyword();
    if (answer == "") {
      // 퀴즈를 모두 풀었으면 결과 화면으로 이동
      // _timer를 취소하기 위해 RemoveUntil로 페이지 삭제
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => QuizResultScreen()),
          ((route) => false));
    }

    title = quizAPI.getTitle();
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void timerReset() {
    _timer?.cancel();
    _timer = setMementoTimer();
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
                        controller: mementoController,
                        readOnly: true,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        style: CustomTheme.themeData.textTheme.bodyMedium,
                      ),
                    ),
                  )
                ]),
              ),
              if (mementoWord != "")
                Keyword(
                  content: mementoWord,
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
                title,
                style: CustomTheme.themeData.textTheme.titleSmall,
              )
            ],
          ),
          Column(
            children: [
              if (userWord != "")
                Keyword(
                  content: userWord,
                  boxColor: const Color(0xFFA6DAFB),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                      border: inputBorderStyle,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0))),
                  child: TextField(
                    controller: userController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(border: InputBorder.none),
                    style: CustomTheme.themeData.textTheme.bodyMedium,
                    onSubmitted: (value) {
                      if (value == answer) {
                        inputBorderStyle = Border.all(
                            color: CustomTheme.themeData.primaryColor);
                        userWord = value; // 사용자 키워드
                        quizAPI.setAnswer(isAnswer: true); // 사용자 정답 처리
                        userController.clear();
                        getNextQuiz();
                        timerReset(); // 시간 초기화
                      } else {
                        // 틀렸음을 표시하는 TextField border 스타일
                        setState(() {
                          inputBorderStyle = Border.all(color: Colors.red);
                        });
                      }
                    },
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
