import 'package:flutter/material.dart';

import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';

class NoteScreen extends StatelessWidget {
  final String noteId; // id로 노트 내용 불러오기

  NoteScreen({required this.noteId});

  String testNote =
      "모인대상발명의 구성을 일부 변경하였더라도, 그 변경이 통상의 기술자가 보통으로 채용하는 정도에 지나지 않고 그로 인하여 발명의 작용효과에 특별한 차이를 일으키지 않는 등 기술적 사상의 창작에 실질적으로 기여하지 않은 경우에 무권리자 출원에 해당한다.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        leading: const BackIconButton(),
        actions: [
          TextButton(
            onPressed: () {
              // 노트 삭제 dialog
              // 삭제 시 노트 리스트로 이동
            },
            child: const Text("삭제"),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "모인대상발명을 변경하여 출원한 경우",
            style: CustomTheme.themeData.textTheme.titleMedium,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            testNote,
          )
          // 실제로 사용할 위젯은 아래
          // KeywordText(selectedText: selectedText)
        ]),
      ),
    );
  }
}
