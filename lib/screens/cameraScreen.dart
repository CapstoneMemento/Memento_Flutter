import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:memento_flutter/screens/displayPictureScreen.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({
    super.key,
    required this.camera,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.camera, ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: CameraPreview(controller),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.radio_button_checked_outlined),
        onPressed: () async {
          final path = p.join(
            // 본 예제에서는 임시 디렉토리에 이미지를 저장합니다. `path_provider`
            // 플러그인을 사용하여 임시 디렉토리를 찾으세요.
            (await getTemporaryDirectory()).path,
            '${DateTime.now()}.png',
          );
          await controller.takePicture();

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(imagePath: path)));
        },
      ),
    );
  }
}
