import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memento_flutter/api/quiz_api.dart';
import 'package:memento_flutter/screen/quiz/quiz_result_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';

class QuizGameScreen extends StatefulWidget {
  const QuizGameScreen();

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  Widget mementoImage = SvgPicture.asset('assets/images/logo_down.svg',
      semanticsLabel: '판례 제목을 쳐다보고 있는 메멘토 캐릭터 로고');
  String mementoWord = ""; // 메멘토가 최근에 획득한 키워드
  String userWord = ""; // 사용자가 최근에 획득한 키워드
  String answer = "";
  String title = "";
  late Timer _timer;
  QuizAPI quizAPI = QuizAPI();

  final TextEditingController mementoController = TextEditingController();
  final TextEditingController userController = TextEditingController();

  var inputBorderStyle = Border.all(color: CustomTheme.themeData.primaryColor);

  @override
  void initState() {
    super.initState();
    mementoController.text = '. . .'; // Set the initial value
    quizAPI.fetchQuizList().then((_) {
      answer = quizAPI.getKeyword(); // 첫 번째 정답
      title = quizAPI.getTitle(); // 첫 번째 제목
      _timer = setMementoTimer();
      setState(() {});
    });
  }

  Timer setMementoTimer() {
    return Timer.periodic(const Duration(seconds: 10), (timer) {
      quizAPI.setAnswer(isUserAnswer: false); // 컴퓨터 정답 처리 (사용자 오답)
      mementoWord = answer;
      delayMemento(isUserAnswer: false); // textField와 mementoWord 표시
      getNextQuiz();
    });
  }

  void delayMemento({required bool isUserAnswer}) {
    // 사용자가 정답이면
    // 1초 동안 고민하는 메멘토 이미지 표시
    if (isUserAnswer) {
      setState(() {
        mementoImage = SvgPicture.asset('assets/images/logo_think.svg',
            semanticsLabel: '고민하는 메멘토 캐릭터 로고');
      });
      Future.delayed(const Duration(seconds: 1), () {
        mementoImage = SvgPicture.asset('assets/images/logo_down.svg',
            semanticsLabel: '판례 제목을 쳐다보고 있는 메멘토 캐릭터 로고');
        setState(() {});
      });
    } else {
      // 1초 동안 기뻐하는 메멘토 이미지 보이기
      // 1초 동안 TextField에 메멘토 정답 표시
      setState(() {
        mementoController.text = answer;
        mementoImage = SvgPicture.asset('assets/images/logo_happy.svg',
            semanticsLabel: '기뻐하는 메멘토 캐릭터 로고');
      });
      Future.delayed(const Duration(seconds: 1), () {
        mementoController.text = ". . .";
        mementoImage = SvgPicture.asset('assets/images/logo_down.svg',
            semanticsLabel: '판례 제목을 쳐다보고 있는 메멘토 캐릭터 로고');
        setState(() {});
      });
    }
  }

  void getNextQuiz() {
    answer = quizAPI.getKeyword();
    if (answer == "") {
      // 퀴즈를 모두 풀었으면 결과 화면으로 이동
      // _timer를 취소하기 위해 RemoveUntil로 페이지 삭제
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  QuizResultScreen(answerList: quizAPI.getAnswerList())),
          ((route) => false));
    } else {
      setState(() {
        title = quizAPI.getTitle(); // (한 문제를 다 풀었으면) 다음 판례 제목 가져오기
      });
    }
  }

  void _onSubmitted(value) {
    // 띄어쓰기 제거 후 정답 비교
    final trimedValue = value.trim().replaceAll(" ", "");
    final trimedAnswer = answer.trim().replaceAll(" ", "");

    if (trimedValue == trimedAnswer) {
      delayMemento(isUserAnswer: true);
      inputBorderStyle = Border.all(color: CustomTheme.themeData.primaryColor);
      userWord = value; // 사용자 키워드
      quizAPI.setAnswer(isUserAnswer: true); // 사용자 정답 처리
      userController.clear();
      getNextQuiz();
      resetTimer(); // 시간 초기화
    } else {
      // 틀렸음을 표시하는 TextField border 스타일
      setState(() {
        inputBorderStyle = Border.all(color: Colors.red);
      });
    }
  }

  // 메멘토 타이머 초기화
  void resetTimer() {
    _timer.cancel();
    _timer = setMementoTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
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
                  mementoImage,
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
                KeywordWidget(
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
                KeywordWidget(
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
                    onSubmitted: _onSubmitted,
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

class KeywordWidget extends StatelessWidget {
  final String content;
  final Color? boxColor;

  const KeywordWidget(
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
