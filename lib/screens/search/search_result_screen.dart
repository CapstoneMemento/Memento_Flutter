import 'package:flutter/material.dart';
import 'package:memento_flutter/api/search_api.dart';
import 'package:memento_flutter/screens/search/search_note_screen.dart';

import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/loading.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;

  const SearchResultScreen({required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late Future searchList;

  @override
  void initState() {
    super.initState();
    searchList = SearchAPI.fetchSearchList(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        leading: const BackIconButton(),
        title: SearchBar(initialValue: widget.query),
      ),
      body: FutureBuilder(
          future: searchList,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
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
                              text: "${snapshot.data.length}",
                              style: TextStyle(
                                  color: CustomTheme.themeData.primaryColor,
                                  fontWeight: FontWeight.w700)),
                          const TextSpan(text: '개'),
                        ],
                      )),
                      const SizedBox(
                        height: 12,
                      ),
                      ResultList(result: snapshot.data)
                    ]),
              );
            } else {
              return Loading();
            }
          })),
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
