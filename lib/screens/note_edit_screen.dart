import 'package:flutter/material.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';
import 'package:memento_flutter/widgets/base_app_bar.dart';

class NoteEditScreen extends StatefulWidget {
  final String extractedText;

  const NoteEditScreen({required this.extractedText});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late String editedText = widget.extractedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        leading: const BackIconButton(),
        actions: [
          TextButton(
            child: const Text("저장"),
            onPressed: () {
              Navigator.pop(context, editedText);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          child: TextFormField(
            initialValue: widget.extractedText,
            maxLines: 100,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: "내용을 입력하세요.",
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
            style: CustomTheme.themeData.textTheme.bodyMedium,
            onChanged: (value) {
              setState(() {
                editedText = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
