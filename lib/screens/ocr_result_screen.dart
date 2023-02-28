import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/home.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';

class OCRResultScreen extends StatelessWidget {
  const OCRResultScreen({required this.imageURL, required this.extractedText});

  final String imageURL;
  final String extractedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              icon: const Icon(Icons.close, color: Colors.black))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageURL),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "텍스트 추출 결과",
                  style: CustomTheme.themeData.textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(extractedText)
              ],
            ),
          )
        ],
      ),
    );
  }
}
