import 'package:flutter/material.dart';
import 'package:memento_flutter/themes/custom_theme.dart';

class ListButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final void Function()? onTap;

  const ListButton({required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
            width: 1,
            color: Colors.black26,
          )),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              icon,
              const SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: CustomTheme.themeData.textTheme.bodyMedium,
              )
            ],
          ),
        ),
      ),
    );
  }
}
