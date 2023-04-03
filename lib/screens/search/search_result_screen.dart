import 'package:flutter/material.dart';

import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;
  int count = 5; // 검색 결과 개수

  SearchResultScreen({required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  // DB에서 불러온 검색 결과
  List<Map<String, dynamic>> result = [
    {
      "id": "1",
      "title": "특허법원 2018. 5. 18. 선고 2017나2271 판결 [특허·실용신안권 침해금지 등]",
      "content":
          "송금의뢰인이 착오송금임을 이유로 거래은행을 통하여 혹은 수취은행에 직접 송금액의 반환을 요청하고, 수취인도 송금의뢰인의 착오송금에 의하여 수취인의 계좌에 금원이 입금된 사실을 인정하여 수취은행에 그 반환을 승낙하고 있는 경우, 수취은행이 수취인에 대한 대출채권 등을 자동채권으로 하여 수취인의 계좌에 착오로 입금된 금원 상당의 예금채권과 상계하는 것은 수취은행이 선의인 상태에서 수취인의 예금채권을 담보로 대출을 하여 그 자동채권을 취득한 것이라거나 그 예금채권이 이미 제3자에 의하여 압류되었다는 등의 특별한 사정이 없는 한, 공공성을 지닌 자금이체시스템의 운영자가 그 이용자인 송금의뢰인의 실수를 기화로 그의 희생하에 당초 기대하지 않았던 채권회수의 이익을 취하는 행위로서 상계제도의 목적이나 기능을 일탈하고 법적으로 보호받을 만한 가치가 없으므로, 송금의뢰인에 대한 관계에서 신의칙에 반하거나 상계에 관한 권리를 남용하는 것이다."
    },
    {
      "id": "2",
      "title": "특허법원 2018. 5. 18. 선고 2017나2271 판결 [특허·실용신안권 침해금지 등]",
      "content":
          "송금의뢰인이 착오송금임을 이유로 거래은행을 통하여 혹은 수취은행에 직접 송금액의 반환을 요청하고, 수취인도 송금의뢰인의 착오송금에 의하여 수취인의 계좌에 금원이 입금된 사실을 인정하여 수취은행에 그 반환을 승낙하고 있는 경우, 수취은행이 수취인에 대한 대출채권 등을 자동채권으로 하여 수취인의 계좌에 착오로 입금된 금원 상당의 예금채권과 상계하는 것은 수취은행이 선의인 상태에서 수취인의 예금채권을 담보로 대출을 하여 그 자동채권을 취득한 것이라거나 그 예금채권이 이미 제3자에 의하여 압류되었다는 등의 특별한 사정이 없는 한, 공공성을 지닌 자금이체시스템의 운영자가 그 이용자인 송금의뢰인의 실수를 기화로 그의 희생하에 당초 기대하지 않았던 채권회수의 이익을 취하는 행위로서 상계제도의 목적이나 기능을 일탈하고 법적으로 보호받을 만한 가치가 없으므로, 송금의뢰인에 대한 관계에서 신의칙에 반하거나 상계에 관한 권리를 남용하는 것이다."
    },
    {
      "id": "3",
      "title": "특허법원 2018. 5. 18. 선고 2017나2271 판결 [특허·실용신안권 침해금지 등]",
      "content":
          "송금의뢰인이 착오송금임을 이유로 거래은행을 통하여 혹은 수취은행에 직접 송금액의 반환을 요청하고, 수취인도 송금의뢰인의 착오송금에 의하여 수취인의 계좌에 금원이 입금된 사실을 인정하여 수취은행에 그 반환을 승낙하고 있는 경우, 수취은행이 수취인에 대한 대출채권 등을 자동채권으로 하여 수취인의 계좌에 착오로 입금된 금원 상당의 예금채권과 상계하는 것은 수취은행이 선의인 상태에서 수취인의 예금채권을 담보로 대출을 하여 그 자동채권을 취득한 것이라거나 그 예금채권이 이미 제3자에 의하여 압류되었다는 등의 특별한 사정이 없는 한, 공공성을 지닌 자금이체시스템의 운영자가 그 이용자인 송금의뢰인의 실수를 기화로 그의 희생하에 당초 기대하지 않았던 채권회수의 이익을 취하는 행위로서 상계제도의 목적이나 기능을 일탈하고 법적으로 보호받을 만한 가치가 없으므로, 송금의뢰인에 대한 관계에서 신의칙에 반하거나 상계에 관한 권리를 남용하는 것이다."
    },
    {
      "id": "4",
      "title": "특허법원 2018. 5. 18. 선고 2017나2271 판결 [특허·실용신안권 침해금지 등]",
      "content":
          "송금의뢰인이 착오송금임을 이유로 거래은행을 통하여 혹은 수취은행에 직접 송금액의 반환을 요청하고, 수취인도 송금의뢰인의 착오송금에 의하여 수취인의 계좌에 금원이 입금된 사실을 인정하여 수취은행에 그 반환을 승낙하고 있는 경우, 수취은행이 수취인에 대한 대출채권 등을 자동채권으로 하여 수취인의 계좌에 착오로 입금된 금원 상당의 예금채권과 상계하는 것은 수취은행이 선의인 상태에서 수취인의 예금채권을 담보로 대출을 하여 그 자동채권을 취득한 것이라거나 그 예금채권이 이미 제3자에 의하여 압류되었다는 등의 특별한 사정이 없는 한, 공공성을 지닌 자금이체시스템의 운영자가 그 이용자인 송금의뢰인의 실수를 기화로 그의 희생하에 당초 기대하지 않았던 채권회수의 이익을 취하는 행위로서 상계제도의 목적이나 기능을 일탈하고 법적으로 보호받을 만한 가치가 없으므로, 송금의뢰인에 대한 관계에서 신의칙에 반하거나 상계에 관한 권리를 남용하는 것이다."
    },
    {
      "id": "5",
      "title": "특허법원 2018. 5. 18. 선고 2017나2271 판결 [특허·실용신안권 침해금지 등]",
      "content":
          "송금의뢰인이 착오송금임을 이유로 거래은행을 통하여 혹은 수취은행에 직접 송금액의 반환을 요청하고, 수취인도 송금의뢰인의 착오송금에 의하여 수취인의 계좌에 금원이 입금된 사실을 인정하여 수취은행에 그 반환을 승낙하고 있는 경우, 수취은행이 수취인에 대한 대출채권 등을 자동채권으로 하여 수취인의 계좌에 착오로 입금된 금원 상당의 예금채권과 상계하는 것은 수취은행이 선의인 상태에서 수취인의 예금채권을 담보로 대출을 하여 그 자동채권을 취득한 것이라거나 그 예금채권이 이미 제3자에 의하여 압류되었다는 등의 특별한 사정이 없는 한, 공공성을 지닌 자금이체시스템의 운영자가 그 이용자인 송금의뢰인의 실수를 기화로 그의 희생하에 당초 기대하지 않았던 채권회수의 이익을 취하는 행위로서 상계제도의 목적이나 기능을 일탈하고 법적으로 보호받을 만한 가치가 없으므로, 송금의뢰인에 대한 관계에서 신의칙에 반하거나 상계에 관한 권리를 남용하는 것이다."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        leading: const BackIconButton(),
        title: SearchBar(initialValue: widget.query),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RichText(
              text: TextSpan(
            style: CustomTheme.themeData.textTheme.bodyMedium,
            text: "검색 결과 ",
            children: <TextSpan>[
              TextSpan(
                  text: "${widget.count}",
                  style: TextStyle(
                      color: CustomTheme.themeData.primaryColor,
                      fontWeight: FontWeight.w700)),
              const TextSpan(text: '개'),
            ],
          )),
          const SizedBox(
            height: 12,
          ),
          ResultList(result: result)
        ]),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  String initialValue;

  SearchBar({required this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.all(Radius.circular(100))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.search,
              size: 24,
              color: Color(0xFF323232),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                initialValue: initialValue,
                style: CustomTheme.themeData.textTheme.bodyMedium,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "판례 번호나 내용을 입력하세요",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
                onFieldSubmitted: (value) {
                  // 검색 결과 가져오기
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultList extends StatelessWidget {
  const ResultList({
    required this.result,
  });

  final List<Map<String, dynamic>> result;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: result
            .map((item) => Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1, color: Colors.black26))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTileTheme(
                      contentPadding: EdgeInsets.zero,
                      child: ListTile(
                        title: Text(
                          item["title"],
                          style: CustomTheme.themeData.textTheme.titleSmall,
                        ),
                        subtitle: Text(
                          item["content"],
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
