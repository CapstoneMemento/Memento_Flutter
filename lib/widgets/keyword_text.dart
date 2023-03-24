import 'package:flutter/material.dart';

class KeywordText extends StatelessWidget {
  final List<Map<String, dynamic>> selectedText;

  KeywordText({required this.selectedText});

  // 선택한 문자 text style
  final highlightStyle =
      TextStyle(backgroundColor: Colors.yellow.withOpacity(0.5));

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
          children: selectedText
              .map((e) => TextSpan(
                  text: e["text"],
                  style: e["isKeyword"] ? highlightStyle : const TextStyle()))
              .toList()),
      toolbarOptions: const ToolbarOptions(selectAll: false),
    );
  }
}
