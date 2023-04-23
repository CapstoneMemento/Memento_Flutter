import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter/api/file_api.dart';
import 'package:memento_flutter/config/constants.dart';
import 'package:memento_flutter/screens/login_screen.dart';
import 'package:memento_flutter/screens/ocr/ocr_result_screen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/list_button.dart';
import 'package:memento_flutter/widgets/loading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet();

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  final List<Map<String, dynamic>> modalItems = [
    // {"id": "edit", "icon": Icons.edit, "text": "직접 입력하기"},
    {"id": "camera", "icon": Icons.camera_alt, "text": "사진 촬영하기"},
    {"id": "photo", "icon": Icons.photo, "text": "앨범에서 가져오기"},
  ];

  late File imageFile; // 로컬 이미지 Path
  String extractedText = ""; // 추출한 텍스트
  bool isLoading = false;

  void _onTap(itemId) async {
    WidgetsFlutterBinding.ensureInitialized();
    // 앨범에서 가져오기
    if (itemId == "photo") {
      openImageScanner(context, source: ScannerFileSource.GALLERY);
    }
    // 사진 촬영하기
    if (itemId == "camera") {
      openImageScanner(context, source: ScannerFileSource.CAMERA);
    }
    // modalBottomSheet 닫기
    Navigator.of(context).pop();
  }

  /* 이미지 스캐너 실행 */
  void openImageScanner(BuildContext context,
      {required ScannerFileSource source}) async {
    final image = await DocumentScannerFlutter.launch(context, source: source);

    if (image != null) {
      setState(() {
        isLoading = true;
        imageFile = image;
      });

      final imageDownloadURL =
          await FileAPI.uploadFile(imageFile: image); // 저장소에 사진 저장
      await runOCR(imageDownloadURL);
      // 결과 화면으로 이동
      navigateToOCRResult();
    }
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
      builder: (context) =>
          OCRResultScreen(imageFile: imageFile, content: extractedText),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : FloatingActionButton(
            backgroundColor: CustomTheme.themeData.primaryColor,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
              // showMaterialModalBottomSheet(
              //     context: context,
              //     builder: (BuildContext context) {
              //       return SizedBox(
              //         height: 120,
              //         child: (Column(
              //             children: modalItems
              //                 .map((item) => Flexible(
              //                     fit: FlexFit.tight,
              //                     child: ListButton(
              //                       icon: Icon(item["icon"]),
              //                       text: item["text"],
              //                       onTap: () => _onTap(item["id"]),
              //                     )))
              //                 .toList())),
              //       );
              //     });
            },
            child: const Icon(Icons.add),
          );
  }
}
