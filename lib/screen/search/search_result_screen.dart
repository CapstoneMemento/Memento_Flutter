import 'package:flutter/material.dart';
import 'package:memento_flutter/api/search_api.dart';
import 'package:memento_flutter/screen/search/search_note_screen.dart';

import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/loading.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;

  const SearchResultScreen({required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  dynamic bodyWidget = Loading();
  bool isLoading = true;
  List resultList = [];

  @override
  void initState() {
    super.initState();
    SearchAPI.fetchSearchList(widget.query).then((value) => {
          setState(
            () {
              resultList = value;
              isLoading = false;
            },
          )
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              // 이전 버튼 누르면 검색 화면으로 이동
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => NavigationBarWidget(
                            selectedIndex: 1,
                          )),
                  (route) => false);
            },
          ),
          title: Container(
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
                  // 검색 바
                  Expanded(
                      child: TextFormField(
                          initialValue: widget.query,
                          style: CustomTheme.themeData.textTheme.bodyMedium,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "판례 번호나 내용을 입력하세요",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                          onFieldSubmitted: (value) async {
                            // 검색 결과 가져오기
                            if (value.isNotEmpty) {
                              setState(() {
                                isLoading = true;
                              });

                              final result =
                                  await SearchAPI.fetchSearchList(value);
                              setState(() {
                                resultList = result;
                                isLoading = false;
                              });
                            }
                          })),
                ],
              ),
            ),
          ),
        ),
        body: isLoading
            ? Loading()
            : resultList == []
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("검색 결과가 없습니다."),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                            style: CustomTheme.themeData.textTheme.bodyMedium,
                            text: "검색 결과 ",
                            children: <TextSpan>[
                              TextSpan(
                                  text: "${resultList.length}",
                                  style: TextStyle(
                                      color: CustomTheme.themeData.primaryColor,
                                      fontWeight: FontWeight.w700)),
                              const TextSpan(text: '개'),
                            ],
                          )),
                          const SizedBox(
                            height: 12,
                          ),
                          ResultList(result: resultList)
                        ]),
                  ));
  }
}

class ResultList extends StatelessWidget {
  const ResultList({
    required this.result,
  });

  final List<dynamic> result;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: result
            .map((item) => GestureDetector(
                  onTap: () {
                    // 판례 본문 화면으로 이동
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            SearchNoteScreen(caseInfo: item)));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(width: 1, color: Colors.black26))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SearchListItem(
                        casenum: item["casenum"],
                        name: item["name"],
                        type: item["type"],
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class SearchListItem extends StatelessWidget {
  final String casenum;
  final String name;
  final String type;

  const SearchListItem({
    super.key,
    required this.name,
    required this.casenum,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              casenum,
              style: TextStyle(
                  fontSize: 12, color: CustomTheme.themeData.primaryColor),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              name,
              style: CustomTheme.themeData.textTheme.titleSmall,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              type,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ));
  }
}
