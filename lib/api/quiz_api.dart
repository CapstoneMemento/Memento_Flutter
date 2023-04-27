import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:memento_flutter/config/constants.dart';
import 'package:memento_flutter/utility/storage.dart';

class QuizAPI {
  String mementoWord = "";
  String userWord = "";
  int currentQuizIndex = 0;
  int currentKeywordIndex = 0;
  List answerList = [];
  List quizList = [];

  Future<List> fetchQuizList() async {
    final accessToken = await Storage.getAccessToken();
    final response = await http.get(
      Uri.parse('${Constants.baseURL}/quiz/0'),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      quizList = jsonDecode(utf8.decode(response.bodyBytes));

      if (quizList.isNotEmpty) {
        // answerlist 초기화
        answerList = quizList
            .map((quiz) => {
                  "title": quiz["title"],
                  "keywords": quiz["keywords"]
                      .map((e) => {"text": e, "isAnswer": false})
                      .toList()
                })
            .toList();
      }

      return quizList;
    } else {
      print('Error code: ${response.statusCode}');
      throw Exception('퀴즈를 불러오지 못했습니다.');
    }
  }

  String getAnswer() {
    return quizList[currentQuizIndex]["keywords"][currentKeywordIndex];
  }

  String getTitle() {
    return quizList[currentQuizIndex]["title"];
  }

  String getKeyword() {
    int keywordLength = quizList[currentQuizIndex]["keywords"].length;
    int quizLength = quizList.length;

    // 키워드 인덱스를 벗어나지 않으면 (아직 남은 키워드가 있다면)
    if (currentKeywordIndex < keywordLength) {
      // 키워드 반환 후 키워드 인덱스 증가
      return quizList[currentQuizIndex]["keywords"][currentKeywordIndex++];
    }

    // 해당 퀴즈에서 남은 키워드가 없고
    // 퀴즈를 모두 풀지 않았으면
    if (currentQuizIndex < quizLength - 1) {
      // 키워드 인덱스 0으로 초기화
      currentKeywordIndex = 0;
      // 퀴즈 인덱스 증가 (다음 퀴즈로 이동)
      return quizList[++currentQuizIndex]["keywords"][currentKeywordIndex++];
    }

    // 퀴즈를 모두 풀었으면
    return "";
  }

  void setAnswer({required isUserAnswer}) {
    answerList[currentQuizIndex]["keywords"][currentKeywordIndex - 1]
        ["isUserAnswer"] = isUserAnswer;
  }

  List getAnswerList() {
    return answerList;
  }
}
