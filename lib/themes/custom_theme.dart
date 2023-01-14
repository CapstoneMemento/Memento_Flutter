import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData themeData = ThemeData(
    fontFamily: "NotoSansKR",
    primaryColor: const Color(0xFF4CA2DA),
    textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: Color(0xff828282))),
  );
}
