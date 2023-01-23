import 'package:flutter/material.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Home extends StatelessWidget {
  Home({
    Key? key,
  }) : super(key: key);

  final List<Map<String, dynamic>> modalItems = [
    {"icon": Icons.edit, "text": "직접 입력하기"},
    {"icon": Icons.camera_alt, "text": "사진 촬영하기"},
    {"icon": Icons.photo, "text": "앨범에서 가져오기"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("내 암기장"),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: CustomTheme.themeData.textTheme.titleLarge,
        elevation: 0,
        toolbarHeight: 60,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomTheme.themeData.primaryColor,
        onPressed: () {
          showMaterialModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 170,
                  child: (Column(
                      children: modalItems
                          .map((e) => Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                  width: 1,
                                  color: Colors.black26,
                                ))),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Wrap(
                                    spacing: 16,
                                    children: [
                                      Icon(e["icon"]),
                                      Text(
                                        e["text"],
                                        style: CustomTheme
                                            .themeData.textTheme.bodyMedium,
                                      )
                                    ],
                                  ),
                                ),
                              ))
                          .toList())),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
