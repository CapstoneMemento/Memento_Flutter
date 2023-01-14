import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:image_picker/image_picker.dart';

import 'package:memento_flutter/themes/custom_theme.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String extractedText = "";

  Future runOcr(String imagePath) async {
    extractedText = await FlutterTesseractOcr.extractText(imagePath,
        language: 'kor',
        args: {
          "preserve_interword_spaces": "1",
        });
    setState(() {});
  }

  Future runFilePicker() async {
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
        child: Text(
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
