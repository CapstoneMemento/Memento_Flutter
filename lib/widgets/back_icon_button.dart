import 'package:flutter/material.dart';

class BackIconButton extends StatelessWidget {
  const BackIconButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      color: Colors.black,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
