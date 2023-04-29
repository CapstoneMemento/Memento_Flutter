import 'package:memento_flutter/api/gpt_api.dart';
import 'package:memento_flutter/api/note_api.dart';

class Keyword {
  static Future getKeywordIndexFromNote({required String content}) async {
    // 노트 저장하고 추천 키워드 받아오기
    final noteId = await NoteAPI.addNote(content: content);
    final recommended = await GptAPI.recommentKeyword(content: content);

    // 추천 키워드 인덱스 추출
    var indexList = getIndexFromWord(
        wordList: recommended, sentence: content, noteId: noteId);

    indexList = indexList.toSet().toList(); // 중복 제거
    sortIndex(indexList: indexList);

    return {"indexList": indexList, "noteId": noteId};
  }

  // 추천 키워드 인덱스 저장 및 반환
  static List getIndexFromWord(
      {required List wordList,
      required String sentence,
      required String noteId}) {
    var result = [];
    var index = 0; // 단어 시작 인덱스

    for (final word in wordList) {
      index = sentence.indexOf(word);

      if (index == -1) {
        continue;
      }

      result.add({
        "first": index,
        "last": index + word.length,
        "noteid": noteId,
      });
    }
    return result;
  }

// 키워드 인덱스 오름차순 정렬
  static void sortIndex({required List indexList}) {
    indexList.sort((a, b) {
      if (a["first"] == b["first"]) {
        return a["last"].compareTo(b["last"]);
      }
      return a["first"].compareTo(b["first"]);
    });
  }
}
