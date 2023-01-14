import 'package:flutter/material.dart';
import 'package:memento_flutter/themes/custom_theme.dart';

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("내 암기장"),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: CustomTheme.themeData.textTheme.titleLarge,
        elevation: 0,
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(children: [
          Container(
            decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(width: 1, color: Colors.black26))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "특허법",
                        style: CustomTheme.themeData.textTheme.titleLarge,
                      ),
                      Text(
                        "저장한 판례 22개",
                        style: CustomTheme.themeData.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const Icon(Icons.notifications_none)
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
