import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/note_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';

class NoteListScreen extends StatelessWidget {
  // DB에서 노트 정보 불러오기
  final List<Map<String, dynamic>> noteList = [
    {
      "id": "1",
      "title": "발명의 완성",
      "content":
          "송금의뢰인이 착오송금임을 이유로 거래은행을 통하여 혹은 수취은행에 직접 송금액의 반환을 요청하고, 수취인도 송금의뢰인의 착오송금에 의하여 수취인의 계좌에 금원이 입금된 사실을 인정하여 수취은행에 그 반환을 승낙하고 있는 경우, 수취은행이 수취인에 대한 대출채권 등을 자동채권으로 하여 수취인의 계좌에 착오로 입금된 금원 상당의 예금채권과 상계하는 것은 수취은행이 선의인 상태에서 수취인의 예금채권을 담보로 대출을 하여 그 자동채권을 취득한 것이라거나 그 예금채권이 이미 제3자에 의하여 압류되었다는 등의 특별한 사정이 없는 한, 공공성을 지닌 자금이체시스템의 운영자가 그 이용자인 송금의뢰인의 실수를 기화로 그의 희생하에 당초 기대하지 않았던 채권회수의 이익을 취하는 행위로서 상계제도의 목적이나 기능을 일탈하고 법적으로 보호받을 만한 가치가 없으므로, 송금의뢰인에 대한 관계에서 신의칙에 반하거나 상계에 관한 권리를 남용하는 것이다."
    },
    {
      "id": "2",
      "title": "수치한정 발명의 의의",
      "content":
          "송금의뢰인이 착오송금임을 이유로 거래은행을 통하여 혹은 수취은행에 직접 송금액의 반환을 요청하고, 수취인도 송금의뢰인의 착오송금에 의하여 수취인의 계좌에 금원이 입금된 사실을 인정하여 수취은행에 그 반환을 승낙하고 있는 경우, 수취은행이 수취인에 대한 대출채권 등을 자동채권으로 하여 수취인의 계좌에 착오로 입금된 금원 상당의 예금채권과 상계하는 것은 수취은행이 선의인 상태에서 수취인의 예금채권을 담보로 대출을 하여 그 자동채권을 취득한 것이라거나 그 예금채권이 이미 제3자에 의하여 압류되었다는 등의 특별한 사정이 없는 한, 공공성을 지닌 자금이체시스템의 운영자가 그 이용자인 송금의뢰인의 실수를 기화로 그의 희생하에 당초 기대하지 않았던 채권회수의 이익을 취하는 행위로서 상계제도의 목적이나 기능을 일탈하고 법적으로 보호받을 만한 가치가 없으므로, 송금의뢰인에 대한 관계에서 신의칙에 반하거나 상계에 관한 권리를 남용하는 것이다."
    }
  ];

  final String category; // 이전 화면에서 선택한 목차

  NoteListScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
            title: Text(category),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black))),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
              children: noteList
                  .map((e) => ListTile(
                        title: Text(
                          e["title"],
                          style: CustomTheme.themeData.textTheme.titleSmall,
                        ),
                        subtitle: Text(
                          e["content"],
                          maxLines: 2,
                        ),
                        trailing: const Icon(Icons.add),
                        onTap: () {
                          // 해당 노트 화면으로 이동
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => NoteScreen())));
                        },
                      ))
                  .toList()),
        ));
  }
}
