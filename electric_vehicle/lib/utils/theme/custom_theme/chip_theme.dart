import 'package:flutter/material.dart';

class EVChipTheme {
  EVChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: Colors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color: Colors.black),
    selectedColor: const Color(0xff269E66),
    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12),
    checkmarkColor: Colors.white,
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    disabledColor: Colors.grey,
    labelStyle: TextStyle(color: Colors.white),
    selectedColor: Color(0xff269E66),
    padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12),
    checkmarkColor: Colors.white,
  );
}