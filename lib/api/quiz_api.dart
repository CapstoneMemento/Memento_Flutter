class QuizAPI {
  String mementoWord = "";
  String userWord = "";
  int currentQuizIndex = 0;
  int currentKeywordIndex = 0;
  late List answerList;
  late List quizList;

  void fetchQuizList() {
    // DB에서 불러오기
    quizList = [
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
      return quizList[++currentQuizIndex]["keywords"][currentKeywordIndex];
    }

    // 퀴즈를 모두 풀었으면
    return "";
  }

  void setAnswer({required isAnswer}) {
    answerList[currentQuizIndex]["keywords"][currentKeywordIndex - 1]
        ["isAnswer"] = isAnswer;
    print(answerList);
  }
}
