import 'package:flutter/material.dart';
import 'package:memento_flutter/widgets/navigation_bar.dart';

class CloseIconButton extends StatelessWidget {
  int selectedIndex;

  CloseIconButton({this.selectedIndex = 0});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close),
      color: Colors.black,
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => NavigationBarWidget(
                      selectedIndex: selectedIndex,
                    )),
            (route) => false);
      },
    );
  }
}
