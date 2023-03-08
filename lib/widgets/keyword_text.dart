import 'package:flutter/material.dart';

class KeywordText extends StatelessWidget {
  final List<List<dynamic>> selectedText;

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
                  text: e[0], style: e[1] ? highlightStyle : const TextStyle()))
              .toList()),
      toolbarOptions: const ToolbarOptions(selectAll: false),
    );
  }
}
