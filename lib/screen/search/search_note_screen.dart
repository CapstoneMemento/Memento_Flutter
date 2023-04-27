import 'package:flutter/material.dart';
import 'package:memento_flutter/api/search_api.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';
import 'package:memento_flutter/widgets/app_bar/base_app_bar.dart';
import 'package:memento_flutter/widgets/loading.dart';

class SearchNoteScreen extends StatelessWidget {
  final Map<String, dynamic> caseInfo;
  late Future contentInfo;

  SearchNoteScreen({required this.caseInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(leading: BackIconButton()),
      body: FutureBuilder(
        future: SearchAPI.fetchContent(caseInfo: caseInfo),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.data?["title"],
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
                  Text(snapshot.data?["sentence"]),
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
                  Text(snapshot.data?["main"]),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "관련 조문",
                    style: CustomTheme.themeData.textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(snapshot.data?["provision"]),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "판결 이유",
                    style: CustomTheme.themeData.textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(snapshot.data?["reason"]),
                  const SizedBox(
                    height: 70,
                  ),
                ],
              ),
            );
          } else {
            return Loading();
          }
        },
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
