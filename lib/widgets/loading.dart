import 'package:flutter/material.dart';
import 'package:memento_flutter/themes/custom_theme.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: CustomTheme.themeData.primaryColor,
      ),
    );
  }
}
