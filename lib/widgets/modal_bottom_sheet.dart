import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import "package:http/http.dart" as http;

import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter/config/constants.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet({super.key});

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
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
                                openImageScanner(context,
                                    source: ScannerFileSource.GALLERY);
                              }
                              // 사진 촬영하기
                              if (e["id"] == "camera") {
                                openImageScanner(context,
                                    source: ScannerFileSource.CAMERA);
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
  openImageScanner(BuildContext context,
      {required ScannerFileSource source}) async {
    final image = await DocumentScannerFlutter.launch(context,
        source: source,
        labelsConfig: {
          ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Step",
          ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
        });

    if (image != null) {
      scannedImage = image;
      final downloadURL = saveImageToStorage();
      runOCR(downloadURL);
    }
  }

/* 저장소에 사진을 저장하고, 다운 URL 받아오기 */
  Future<String> saveImageToStorage() async {
    // Firebase storage에 이미지 저장
    try {
      await scannedImageRef.putFile(scannedImage);
    } catch (error) {
      log(error.toString());
    }
    // image URL 가져오기
    final downloadURL = await scannedImageRef.getDownloadURL();
    return downloadURL;
  }

  /* 입력한 이미지 URL로 네이버 OCR 실행 */
  void runOCR(Future<String> imageURL) async {
    final url = Uri.parse(Constants.invokeURL); // url을 uri로 변환
    final headers = {"X-OCR-SECRET": Constants.secretKey};
    final body = {
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
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));
      final textFields = jsonDecode(response.body).images[0].fields;
    } catch (error) {
      // print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: CustomTheme.themeData.primaryColor,
      onPressed: () {
        showModalBottomSheet(context);
      },
      child: const Icon(Icons.add),
    );
  }
}
