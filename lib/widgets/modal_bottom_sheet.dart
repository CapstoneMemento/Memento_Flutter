import 'dart:io';

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
  String imageDownloadURL = ""; // 저장한 이미지 URL
  String extractedText = ""; // 추출한 텍스트
  bool isLoading = false;

  /* Firebase storage 초기화 */
  final storageRef = FirebaseStorage.instance.ref();
  late final scannedImageRef = storageRef.child("scannedImage.jpg");

  /* 이미지 스캐너 실행 */
  void openImageScanner(BuildContext context,
      {required ScannerFileSource source}) async {
    final image = await DocumentScannerFlutter.launch(context,
        source: source, labelsConfig: {});

    if (image != null) {
      setState(() {
        isLoading = true;
        scannedImage = image;
      });
      //await saveImageToStorage();
      await getImageURL();
      await runOCR(imageDownloadURL);
      navigateToOCRResult(); // 결과 화면으로 이동
    }
  }

  /* 저장소에 사진을 저장 */
  saveImageToStorage() async {
    // Firebase storage에 이미지 저장
    await scannedImageRef.putFile(scannedImage);
  }

  /* 저장소 이미지 URL 가져오기 */
  getImageURL() async {
    /*
    final downloadURL = await scannedImageRef.getDownloadURL();
    setState(() {
      imageDownloadURL = downloadURL;
    });
     */

    // 테스트 코드 //////////////
    setState(() {
      imageDownloadURL =
          "https://t1.daumcdn.net/cfile/tistory/99C34C375B4AEFD71F";
    });
    /////////////////////////////
  }

  /* 입력한 이미지 URL로 네이버 OCR 실행 */
  runOCR(String imageURL) async {
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

/*
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
    */

    // 테스트 코드 //////////
    extractedText =
        "송금의뢰인이 착오송금임을 이유로 거래은행을 통하여 혹은 수취은행에 직접 송금액의 반환을 요청하고, 수취인도 송금의뢰인의 착오송금에 의하여 수취인의 계좌에 금원이 입금된 사실을 인정하여 수취은행에 그 반환을 승낙하고 있는 경우, 수취은행이 수취인에 대한 대출채권 등을 자동채권으로 하여 수취인의 계좌에 착오로 입금된 금원 상당의 예금채권과 상계하는 것은 수취은행이 선의인 상태에서 수취인의 예금채권을 담보로 대출을 하여 그 자동채권을 취득한 것이라거나 그 예금채권이 이미 제3자에 의하여 압류되었다는 등의 특별한 사정이 없는 한, 공공성을 지닌 자금이체시스템의 운영자가 그 이용자인 송금의뢰인의 실수를 기화로 그의 희생하에 당초 기대하지 않았던 채권회수의 이익을 취하는 행위로서 상계제도의 목적이나 기능을 일탈하고 법적으로 보호받을 만한 가치가 없으므로, 송금의뢰인에 대한 관계에서 신의칙에 반하거나 상계에 관한 권리를 남용하는 것이다.";
    setState(() {
      isLoading = false;
    });
    ///////////////////////
  }

  /* 추출한 텍스트 결과 페이지로 이동 */
  void navigateToOCRResult() {
    Navigator.push(
        context,
        MaterialPageRoute(
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
