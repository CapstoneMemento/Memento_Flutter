import 'package:flutter/material.dart';
import 'package:memento_flutter/themes/custom_theme.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/images/logo.png",
          width: 120,
        ),
        const SizedBox(
          height: 32,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
