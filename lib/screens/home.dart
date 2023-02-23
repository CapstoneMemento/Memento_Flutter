import 'dart:io';

import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/subjectScreen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late File scannedImage; // 카메라로 스캔한 이미지

  final List<Map<String, dynamic>> modalItems = [
    {"id": "edit", "icon": Icons.edit, "text": "직접 입력하기"},
    {"id": "camera", "icon": Icons.camera_alt, "text": "사진 촬영하기"},
    {"id": "photo", "icon": Icons.photo, "text": "앨범에서 가져오기"},
  ];

  Future<dynamic> showModalBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 180,
            child: (Column(
                children: modalItems
                    .map((e) => GestureDetector(
                          onTap: () async {
                            WidgetsFlutterBinding.ensureInitialized();

                            // 직접 입력하기
                            if (e["id"] == "edit") {}
                            // 앨범에서 가져오기
                            if (e["id"] == "photo") {
                              runFilePicker(context);
                            }
                            // 사진 촬영하기
                            if (e["id"] == "camera") {
                              openImageScanner(context);
                            }
                          },
                          child: Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                width: 1,
                                color: Colors.black26,
                              ))),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Icon(e["icon"]),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      e["text"],
                                      style: CustomTheme
                                          .themeData.textTheme.bodyMedium,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList())),
          );
        });
  }

  openImageScanner(BuildContext context) async {
    var image = await DocumentScannerFlutter.launch(context,
        source: ScannerFileSource.CAMERA);

    // 촬영한 이미지 저장
    if (image != null) {
      scannedImage = image;
      // 네이버 OCR로 텍스트 추출
      setState(() {});
    }
  }

  runFilePicker(BuildContext context) async {
    var image = await DocumentScannerFlutter.launch(context,
        source: ScannerFileSource.GALLERY);

    // 앨범에서 선택한 이미지 저장
    if (image != null) {
      scannedImage = image;
      // 네이버 OCR로 텍스트 추출
      setState(() {});
    }
  }

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
            child: ListTile(
              title: const Text("특허법"),
              subtitle: const Text("저장한 판례 22개"),
              trailing: const Icon(Icons.notifications_none),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SubjectScreen()));
              },
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomTheme.themeData.primaryColor,
        onPressed: () {
          showModalBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
