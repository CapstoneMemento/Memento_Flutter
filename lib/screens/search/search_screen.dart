import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/search/search_result_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Image.asset(
          "assets/images/logo_no_back.png",
          width: 120,
        ),
        const SizedBox(
          height: 16,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SearchBar(),
        )
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                style: CustomTheme.themeData.textTheme.bodyMedium,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "판례 번호나 내용을 입력하세요",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    // 검색 결과 화면에 검색어 전달
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            SearchResultScreen(query: value)));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
