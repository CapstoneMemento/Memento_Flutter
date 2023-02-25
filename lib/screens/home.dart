import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import "package:http/http.dart" as http;

import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter/config/constants.dart';
import 'package:memento_flutter/screens/subjectListScreen.dart';
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
  final List<Map<String, dynamic>> modalItems = [
    {"id": "edit", "icon": Icons.edit, "text": "직접 입력하기"},
    {"id": "camera", "icon": Icons.camera_alt, "text": "사진 촬영하기"},
    {"id": "photo", "icon": Icons.photo, "text": "앨범에서 가져오기"},
  ];

  late File scannedImage; // 스캔한 이미지

/* Firebase storage 초기화 */

  final storageRef = FirebaseStorage.instance.ref();
  late final scannedImageRef = storageRef.child("scannedImage.jpg");

  Future<dynamic> showModalBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 180,
            child: (Column(
                children: modalItems
                    .map((e) => Flexible(
                          fit: FlexFit.tight,
                          child: GestureDetector(
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

  /* '사진 촬영하기' 선택 시, 문서 스캐너 실행 */
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

/* '앨범에서 가져오기' 선택 시 실행하는 함수 */
  runFilePicker(BuildContext context) async {
    // 앨범 실행
    var image = await DocumentScannerFlutter.launch(context,
        source: ScannerFileSource.GALLERY);

    // 앨범에서 선택한 이미지 저장
    if (image != null) {
      scannedImage = image;

      // Firebase storage에 이미지 저장
      try {
        await scannedImageRef.putFile(scannedImage);
      } catch (error) {
        log(error.toString());
      }
      // image URL 가져오기
      var downloadURL = await scannedImageRef.getDownloadURL();
      runOCR(downloadURL);
    }
  }

  /* 네이버 OCR 실행 */
  void runOCR(String imageURL) async {
    var url = Uri.parse(Constants.invokeURL); // url을 uri로 변환
    var headers = {"X-OCR-SECRET": Constants.secretKey};
    var body = {
      "images": [
        {"format": "jpeg", "name": "note", "data": null, "url": imageURL}
      ],
      "lang": "ko",
      "requestId": "string",
      "timestamp": 0,
      "version": "V2",
      "enableTableDetection": false
    }; // images 안에 List 때문에 object로 인식되지 않으므로, jsonEncode 사용
    try {
      var response =
          await http.post(url, headers: headers, body: jsonEncode(body));
      // print(jsonDecode(response.body)); // 응답 확인 완료
    } catch (error) {
      // print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("내 암기장"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
                        builder: (context) => const SubjectListScreen()));
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
