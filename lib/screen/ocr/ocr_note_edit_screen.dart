import 'package:flutter/material.dart';
import 'package:memento_flutter/themes/custom_theme.dart';
import 'package:memento_flutter/widgets/app_bar/main_app_bar.dart';
import 'package:memento_flutter/widgets/back_icon_button.dart';

class NoteEditScreen extends StatefulWidget {
  final String content;

  const NoteEditScreen({required this.content});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late String editedText = widget.content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
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
            initialValue: widget.content,
            maxLines: (widget.content.length / 30).ceil(),
            decoration: const InputDecoration(
              border: InputBorder.none,
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
