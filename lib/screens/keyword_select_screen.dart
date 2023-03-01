import 'package:flutter/material.dart';

import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';

class KeywordSelectScreen extends StatelessWidget {
  final String extractedText;

  const KeywordSelectScreen({required this.extractedText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        actions: [
          Icon(
            Icons.close,
            color: Colors.black,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          Text(
            "키워드를 선택하세요",
            style: CustomTheme.themeData.textTheme.titleMedium,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(extractedText)
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 판례 제목 지정으로 이동
        },
        backgroundColor: CustomTheme.themeData.primaryColor,
        child: const Icon(Icons.check),
      ),
    );
  }
}
