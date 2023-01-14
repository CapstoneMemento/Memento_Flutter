import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:image_picker/image_picker.dart';

import 'package:memento_flutter/themes/custom_theme.dart';

class TesseractOcrTest extends StatefulWidget {
  const TesseractOcrTest({
    Key? key,
  }) : super(key: key);

  @override
  State<TesseractOcrTest> createState() => _TesseractOcrTestState();
}

class _TesseractOcrTestState extends State<TesseractOcrTest> {
  String extractedText = "";
  bool isLoading = false;

  Future runOcr(String imagePath) async {
    extractedText = await FlutterTesseractOcr.extractText(imagePath,
        language: 'kor+eng+chi_tra',
        args: {
          "preserve_interword_spaces": "1",
        });
    setState(() {
      isLoading = false;
    });
  }

  Future runFilePicker() async {
    setState(() {
      isLoading = true;
    });
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await runOcr(pickedFile.path);
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
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                extractedText,
                style: CustomTheme.themeData.textTheme.bodyMedium,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomTheme.themeData.primaryColor,
        onPressed: runFilePicker,
        child: const Icon(Icons.add),
      ),
    );
  }
}
