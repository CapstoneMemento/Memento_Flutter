import 'package:flutter/material.dart';

class KeywordText extends StatelessWidget {
  final List selectedText;

  KeywordText({required this.selectedText});

  // 선택한 문자 text style
  final highlightStyle =
      TextStyle(fontSize: 16, backgroundColor: Colors.yellow.withOpacity(0.5));

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
          children: selectedText
              .map((e) => TextSpan(
                  text: e["text"],
                  style: e["isKeyword"]
                      ? highlightStyle
                      : const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 2)))
              .toList()),
      toolbarOptions: const ToolbarOptions(selectAll: false),
    );
  }
}
