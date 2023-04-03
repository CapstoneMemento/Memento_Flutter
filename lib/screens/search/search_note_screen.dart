import 'package:flutter/material.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';

class SearchNoteScreen extends StatelessWidget {
  SearchNoteScreen();

  Map<String, dynamic> note = {
    "title": "특허법원 2018. 5. 18. 선고 2017나2271 판결 [특허·실용신안권 침해금지 등]",
    "judgment":
        "송금의뢰인이 착오송금임을 이유로 수취은행에 송금액의 반환을 요청하고 수취인도 착오송금을 인정하여 수취은행에 반환을 승낙하고 있는 경우, 수취은행이 수취인에 대한 대출채권 등을 자동채권으로 하여 수취인 계좌에 착오송금된 금원 상당의 예금채권과 상계하는 것이 송금의뢰인에 대한 관계에서 신의칙에 반하거나 상계권 남용인지 여부(원칙적 적극) / 이때 수취인의 계좌에 착오로 입금된 금원 상당의 예금채권이 이미 제3자에 의하여 압류되었다는 특별한 사정이 있는 경우, 수취은행이 수취인에 대한 대출채권 등을 자동채권으로 하여 수취인의 예금채권과 상계할 수 있는 범위(=피압류채권액의 범위 내)",
    "summary":
        "송금의뢰인이 착오송금임을 이유로 수취은행에 송금액의 반환을 요청하고 수취인도 착오송금을 인정하여 수취은행에 반환을 승낙하고 있는 경우, 수취은행이 수취인에 대한 대출채권 등을 자동채권으로 하여 수취인 계좌에 착오송금된 금원 상당의 예금채권과 상계하는 것이 송금의뢰인에 대한 관계에서 신의칙에 반하거나 상계권 남용인지 여부(원칙적 적극) / 이때 수취인의 계좌에 착오로 입금된 금원 상당의 예금채권이 이미 제3자에 의하여 압류되었다는 특별한 사정이 있는 경우, 수취은행이 수취인에 대한 대출채권 등을 자동채권으로 하여 수취인의 예금채권과 상계할 수 있는 범위(=피압류채권액의 범위 내)",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(leading: BackIconButton()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note["title"],
              style: CustomTheme.themeData.textTheme.titleMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "판시사항",
              style: CustomTheme.themeData.textTheme.titleSmall,
            ),
            const SizedBox(
              height: 14,
            ),
            Text(note["judgment"]),
            const SizedBox(
              height: 20,
            ),
            Text(
              "판결요지",
              style: CustomTheme.themeData.textTheme.titleSmall,
            ),
            const SizedBox(
              height: 14,
            ),
            Text(note["summary"]),
            const SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text(
          "저장",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        onPressed: () {
          // 판례 저장
        },
      ),
    );
  }
}
