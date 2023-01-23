import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter/screens/cameraScreen.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatelessWidget {
  Home({
    Key? key,
  }) : super(key: key);

  final List<Map<String, dynamic>> modalItems = [
    {"id": "edit", "icon": Icons.edit, "text": "직접 입력하기"},
    {"id": "camera", "icon": Icons.camera_alt, "text": "사진 촬영하기"},
    {"id": "photo", "icon": Icons.photo, "text": "앨범에서 가져오기"},
  ];

  Future<dynamic> showModalBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 180,
            child: (Column(
                children: modalItems
                    .map((e) => GestureDetector(
                          onTap: () async {
                            WidgetsFlutterBinding.ensureInitialized();
                            final List<CameraDescription> cameras =
                                await availableCameras();

                            if (e["id"] == "edit") {
                              // 직접 입력하기
                            }
                            if (e["id"] == "photo") {
                              runFilePicker();
                            }
                            if (e["id"] == "camera") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CameraScreen(
                                            camera: cameras.first,
                                          )));
                            }
                          },
                          child: Flexible(
                            fit: FlexFit.tight,
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

  Future runFilePicker() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // run OCR
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
        toolbarHeight: 60,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(children: [
          Container(
            decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(width: 1, color: Colors.black26))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "특허법",
                        style: CustomTheme.themeData.textTheme.titleLarge,
                      ),
                      Text(
                        "저장한 판례 22개",
                        style: CustomTheme.themeData.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const Icon(Icons.notifications_none)
                ],
              ),
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
