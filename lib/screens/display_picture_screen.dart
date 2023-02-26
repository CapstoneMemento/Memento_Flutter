import 'dart:io';

import 'package:flutter/material.dart';

// 촬영한 이미지를 미리 보여주는 화면 (현재 사용 X)
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.file(File(imagePath)),
    );
  }
}
