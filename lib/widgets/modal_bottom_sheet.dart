import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter/config/constants.dart';
import 'package:memento_flutter/screens/ocr_result_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/loading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet();

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  final List<Map<String, dynamic>> modalItems = [
    {"id": "edit", "icon": Icons.edit, "text": "직접 입력하기"},
    {"id": "camera", "icon": Icons.camera_alt, "text": "사진 촬영하기"},
    {"id": "photo", "icon": Icons.photo, "text": "앨범에서 가져오기"},
  ];

  String imageDownloadURL = ""; // 저장한 이미지 URL
  String extractedText = ""; // 추출한 텍스트
  bool isLoading = false;

  /* Firebase storage 초기화 */
  final storageRef = FirebaseStorage.instance.ref();
  late final scannedImageRef = storageRef.child("scannedImage.jpg");

  /* 이미지 스캐너 실행 */
  void openImageScanner(BuildContext context,
      {required ScannerFileSource source}) async {
    final image = await DocumentScannerFlutter.launch(context, source: source);

    if (image != null) {
      setState(() {
        isLoading = true;
      });
      saveImageToStorage(image);
      getImageURL();
      await runOCR(imageDownloadURL);
      // 결과 화면으로 이동
      navigateToOCRResult();
    }
  }

  /* 저장소에 사진 저장 */
  saveImageToStorage(File image) {
    // storage에 이미지 저장
  }

  /* 저장소 이미지 URL 가져오기 */
  getImageURL() {
    imageDownloadURL =
        "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FGEVuv%2Fbtr4w5DtzIJ%2F5RtHFUfCcfrPUggN2hP0O0%2Fimg.png";
  }

  /* 입력한 이미지 URL로 네이버 OCR 실행 */
  runOCR(String imageURL) async {
    final url = Uri.parse(Constants.invokeURL); // url을 uri로 변환
    final headers = {"X-OCR-SECRET": Constants.secretKey};
    final body = {
      "images": [
        {"format": "png", "name": "note", "data": null, "url": imageURL}
      ],
      "lang": "ko",
      "requestId": "string",
      "timestamp": 0,
      "version": "V2",
      "enableTableDetection": false
    }; // images 안에 List 때문에 object로 인식되지 않으므로, jsonEncode 사용

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      final textFields = jsonDecode(response.body)["images"][0]["fields"];

      // 리스트에서 문자만 합치기
      for (final textField in textFields) {
        extractedText += "${textField["inferText"]} ";
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToOCRResult() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => OCRResultScreen(
          imageURL: imageDownloadURL, extractedText: extractedText),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : FloatingActionButton(
            backgroundColor: CustomTheme.themeData.primaryColor,
            onPressed: () {
              showMaterialModalBottomSheet(
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
                                        WidgetsFlutterBinding
                                            .ensureInitialized();

                                        // 직접 입력하기
                                        if (e["id"] == "edit") {}
                                        // 앨범에서 가져오기
                                        if (e["id"] == "photo") {
                                          openImageScanner(context,
                                              source:
                                                  ScannerFileSource.GALLERY);
                                        }
                                        // 사진 촬영하기
                                        if (e["id"] == "camera") {
                                          openImageScanner(context,
                                              source: ScannerFileSource.CAMERA);
                                        }
                                        // modalBottomSheet 닫기
                                        Navigator.of(context).pop();
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
                                                style: CustomTheme.themeData
                                                    .textTheme.bodyMedium,
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
            },
            child: const Icon(Icons.add),
          );
  }
}
