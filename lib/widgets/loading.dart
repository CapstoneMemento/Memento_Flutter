import 'package:flutter/material.dart';
import 'package:memento_flutter/themes/custom_theme.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Opacity(
          opacity: 0.5,
          child: ModalBarrier(dismissible: false),
        ),
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(0.5),
                    color: CustomTheme.themeData.primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("로딩 중..")
              ],
            ),
          ),
        )
      ],
    );
  }
}
