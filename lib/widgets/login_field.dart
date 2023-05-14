import 'package:flutter/material.dart';
import 'package:memento_flutter/themes/custom_theme.dart';

class LoginField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const LoginField(
      {required this.controller,
      required this.hintText,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: const BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.all(Radius.circular(100))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                obscureText: obscureText,
                controller: controller,
                style: CustomTheme.themeData.textTheme.bodyMedium,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
